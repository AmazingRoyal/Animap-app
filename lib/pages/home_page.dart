// ignore_for_file: library_private_types_in_public_api

import 'package:animap/models/season_now.dart';
import 'package:animap/models/top_anime.dart';
import 'package:animap/models/upcoming_anime.dart';
import 'package:animap/pages/detail_anime_page.dart';
import 'package:animap/services/remote_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget 
{
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  TopAnime? topAnimes;
  SeasonNow? seasonNows;
  UpcomingAnime? upcomingAnime;

  var isLoadedTopAnime = false;
  var isLoadedSeasonNow = false;
  var isLoadedUpcomingAnime = false;

  @override
  void initState() 
  {
    super.initState();

    // FETCH DATA FROM API
    getTopAnime();
    getSeasonNow();
    getUpcomingAnime();
  }

  getTopAnime() async
  {
    topAnimes = await RemoteService().getTopAnime();

    if (topAnimes != null) 
    {
      setState(() 
      {
        isLoadedTopAnime = true;
      });
    }
  }

  getSeasonNow() async
  {
    seasonNows = await RemoteService().getSeasonNow();

    if (seasonNows != null) 
    {
      setState(() 
      {
        isLoadedSeasonNow = true;
      });
    }
  }

  getUpcomingAnime() async
  {
    upcomingAnime = await RemoteService().getUpcomingAnime();

    if (seasonNows != null) 
    {
      setState(() 
      {
        isLoadedUpcomingAnime = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        centerTitle: true,
        title: Text
        (
          "OVERVIEW",
          style: TextStyle
          (
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SafeArea
      (
        child: NotificationListener<OverscrollIndicatorNotification>
        (
          onNotification: (overScroll)
          {
            overScroll.disallowIndicator();
            return false;
          },
          child: SingleChildScrollView
          (
            child: Column
            (
              children: 
              [
                // UPCOMING ANIME
                Padding
                (
                  padding: const EdgeInsets.only(left: 24.0, top:24),
                  child: Container
                  (
                    alignment: Alignment.centerLeft,
                    child: Visibility
                    (
                      visible: isLoadedSeasonNow,
                      child: Text
                      (
                        "UPCOMING ANIME",
                        textAlign: TextAlign.left,
                        style: TextStyle
                        (
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                    ),
                  ),
                ),  
                
                // UPCOMING ANIME CONTENT
                SizedBox
                (
                  height: 350,
                  child: Visibility
                  (
                    visible: isLoadedSeasonNow,
                    replacement: const Center
                    (
                      child: CircularProgressIndicator(),
                    ),
                    child: NotificationListener<OverscrollIndicatorNotification>
                    (
                      onNotification: (overScroll)
                      {
                        overScroll.disallowIndicator();
                        return false;
                      },
                      child: ListView.builder
                      (
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: upcomingAnime?.data?.length ?? 0,
                        itemBuilder: (context, index) 
                        {
                          return Padding
                          (
                            padding: EdgeInsets.fromLTRB(index==0?24:8, 22, 8, 22),
                            child: InkWell
                            (
                              onTap: () 
                              {
                                Navigator.push
                                (
                                  context,
                                  MaterialPageRoute
                                  (
                                    builder: (context) => DetailAnimePage(malId: upcomingAnime!.data![index].malId.toString()),
                                  ),
                                );
                              },
                              child: SizedBox
                              (
                                width: 140,
                                child: Column
                                (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> 
                                  [
                                    ClipRRect
                                    (
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image
                                      (
                                        image: NetworkImage(upcomingAnime!.data![index].images['jpg']!.imageUrl),
                                        height: 210,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                
                                    // ANIME TITLE
                                    Padding
                                    (
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text
                                      (
                                        upcomingAnime!.data![index].title.toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle
                                        (
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                
                                    Row
                                    (
                                      children: 
                                      [
                                        Text
                                        (
                                          upcomingAnime!.data![index].episodes.toString(),
                                          style: const TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                        const Text
                                        (
                                          " Eps - ",
                                          style: TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                        Text
                                        (
                                          upcomingAnime!.data![index].duration.toString().replaceAll(" per ep", ""),
                                          style: const TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }),
                    ),
                  ),
                ),
                
                // SEASON NOW
                Padding
                (
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Container
                  (
                    alignment: Alignment.centerLeft,
                    child: Visibility
                    (
                      visible: isLoadedSeasonNow,
                      child: Text
                      (
                        "${seasonNows?.data[0].season.toString().toUpperCase()} ${seasonNows?.data[0].year}",
                        textAlign: TextAlign.left,
                        style: TextStyle
                        (
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                    ),
                  ),
                ),  
                
                // SEASON NOW CONTENT
                SizedBox
                (
                  height: 370,
                  child: Visibility
                  (
                    visible: isLoadedSeasonNow,
                    replacement: const Center
                    (
                      child: CircularProgressIndicator(),
                    ),
                    child: NotificationListener<OverscrollIndicatorNotification>
                    (
                      onNotification: (overScroll)
                      {
                        overScroll.disallowIndicator();
                        return false;
                      },
                      child: ListView.builder
                      (
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: seasonNows?.data.length ?? 0,
                        itemBuilder: (context, index) 
                        {
                          return Padding
                          (
                            padding: EdgeInsets.fromLTRB(index==0?24:8, 22, 8, 22),
                            child: InkWell
                            (
                              onTap: () 
                              {
                                Navigator.push
                                (
                                  context,
                                  MaterialPageRoute
                                  (
                                    builder: (context) => DetailAnimePage(malId: seasonNows!.data[index].malId.toString()),
                                  ),
                                );
                              },
                              child: SizedBox
                              (
                                width: 140,
                                child: Column
                                (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> 
                                  [
                                    ClipRRect
                                    (
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image
                                      (
                                        image: NetworkImage(seasonNows!.data[index].images['jpg']!.imageUrl),
                                        width: 140,
                                        height: 210,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                
                                    // ANIME TITLE
                                    Padding
                                    (
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text
                                      (
                                        seasonNows!.data[index].title.toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle
                                        (
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                
                                    // ANIME SCORE
                                    Row
                                    (
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: 
                                      [
                                        const Text
                                        (
                                          "Score",
                                          style: TextStyle
                                          (
                                            color: Colors.black54,
                                            fontSize: 14
                                          ),
                                        ),
                                        const SizedBox(width: 8,),
                                        Container
                                        (
                                          decoration: BoxDecoration
                                          (
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Padding
                                          (
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                            child: Text
                                            (
                                              seasonNows!.data[index].score.toString(),
                                              style: const TextStyle
                                              (
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                    
                                    Row
                                    (
                                      children: 
                                      [
                                        Text
                                        (
                                          seasonNows!.data[index].episodes.toString(),
                                          style: const TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                        const Text
                                        (
                                          " Eps - ",
                                          style: TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                        Text
                                        (
                                          seasonNows!.data[index].duration.toString().replaceAll(" per ep", ""),
                                          style: const TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }),
                    ),
                  ),
                ),

                // TOP ANIME
                Padding
                (
                  padding: const EdgeInsets.only(left: 24),
                  child: Container
                  (
                    alignment: Alignment.centerLeft,
                    child: Text
                    (
                      "MOST POPULAR ANIME",
                      textAlign: TextAlign.left,
                      style: TextStyle
                      (
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),
                  ),
                ),
        
                // TOP ANIME CONTENT
                SizedBox
                (
                  height: 370,
                  child: Visibility
                  (
                    visible: isLoadedTopAnime,
                    replacement: const Center
                    (
                      child: CircularProgressIndicator(),
                    ),
                    child: NotificationListener<OverscrollIndicatorNotification>
                    (
                      onNotification: (overScroll)
                      {
                        overScroll.disallowIndicator();
                        return false;
                      },
                      child: ListView.builder
                      (
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: topAnimes!.data!.length,
                        itemBuilder: (context, index) 
                        {
                          return Padding
                          (
                            padding: EdgeInsets.fromLTRB(index==0?24:8, 22, 8, 22),
                            child: InkWell
                            (
                              onTap: () 
                              {
                                Navigator.push
                                (
                                  context,
                                  MaterialPageRoute
                                  (
                                    builder: (context) => DetailAnimePage(malId: topAnimes!.data![index].malId.toString()),
                                  ),
                                );
                              },
                              child: SizedBox
                              (
                                width: 140,
                                child: Column
                                (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> 
                                  [
                                    ClipRRect
                                    (
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image
                                      (
                                        image: NetworkImage(topAnimes!.data![index].images['jpg']!.imageUrl),
                                        height: 210,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                
                                    // TOP ANIME CONTENT - TITLE
                                    Padding
                                    (
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        topAnimes!.data![index].title.toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                
                                    // TOP ANIME CONTENT - SCORE
                                    Row
                                    (
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: 
                                      [
                                        const Text
                                        (
                                          "Score",
                                          style: TextStyle
                                          (
                                            color: Colors.black54,
                                            fontSize: 14
                                          ),
                                        ),
                                        const SizedBox(width: 8,),
                                        Container
                                        (
                                          decoration: BoxDecoration
                                          (
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Padding
                                          (
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                            child: Text
                                            (
                                              topAnimes!.data![index].score.toString(),
                                              style: const TextStyle
                                              (
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                    
                                    // TOP ANIME CONTENT - EPISODE & DURATION 
                                    Row
                                    (
                                      children: 
                                      [
                                        Text
                                        (
                                          topAnimes!.data![index].episodes.toString(),
                                          style: const TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                        const Text
                                        (
                                          " Eps - ",
                                          style: TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                        Text
                                        (
                                          topAnimes!.data![index].duration.toString().replaceAll(" per ep", ""),
                                          style: const TextStyle
                                          (
                                            fontSize: 13,
                                            color: Colors.black54
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      )
    );
  }
}