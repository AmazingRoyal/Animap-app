import 'package:animap/models/detail_anime.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/remote_service.dart';

import 'dart:developer' as log_dev;

class DetailAnimePage extends StatefulWidget 
{
  const DetailAnimePage({super.key, required this.malId});

  final String malId;

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> 
{ 

  DetailAnime? detailAnimes;
  var isLoaded = false;
  double gapSpace = 8.0;
  List<Widget> listProducers = <Widget>[];
  List<Widget> listLisencors = <Widget>[];
  List<String> listGenres = <String>[];
  List<Widget> listThemes = <Widget>[];

  @override
  void initState() 
  {
    setState(() 
      {
        isLoaded = false;
      });
    getDetailAnime(widget.malId);
    super.initState();

    // FETCH DATA FROM API
  }

  getDetailAnime(var malId) async
  {
    detailAnimes = await RemoteService(malId: malId).getDetailAnime();

    if (detailAnimes != null) 
    {
      setState(() 
      {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    // FORMAT DATA LIST
    listProducers.clear();
    listLisencors.clear();
    listGenres.clear();
    listThemes.clear();

    // CONVERT ARRAY TO TEXT LIST
    // PRODUCERS
    for (int i = 0; i < detailAnimes!.data!.producers.length; i++) 
    {
      listProducers.add
      (
        Text(detailAnimes!.data!.producers[i].name.toString()),
      );
    }
    // LISENCORS
    for (int i = 0; i < detailAnimes!.data!.licensors.length; i++) 
    {
      listLisencors.add
      (
        Text(detailAnimes!.data!.licensors[i].name.toString()),
      );
    }
    // GENRES
    for (int i = 0; i < detailAnimes!.data!.genres.length; i++) 
    {
      listGenres.add
      (
        detailAnimes!.data!.genres[i].name.toString()
      );
    }
    // THEMES
    for (int i = 0; i < detailAnimes!.data!.themes.length; i++) 
    {
      listThemes.add
      (
        Text(detailAnimes!.data!.themes[i].name.toString()),
      );
    }

    YoutubePlayerController controller = YoutubePlayerController(
        initialVideoId: detailAnimes!.data!.trailer.youtubeId,
        flags: const YoutubePlayerFlags(
          controlsVisibleAtStart: true,
          autoPlay: false,
          mute: true,
        ),
    );

    return Scaffold
    (
      body: SafeArea
      (
        child: SingleChildScrollView(
          child: Visibility
          (
            visible: isLoaded,
            replacement: const Center
            (
              child: CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.center,
                children: 
                [
                  Container
                  (
                    decoration: BoxDecoration
                    (
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow
                        (
                          color: Colors.grey.withOpacity(.7),
                          spreadRadius: 5,
                          blurRadius: 16,
                          offset: const Offset(0, 3),
                        )
                      ]
                    ),
                    child: YoutubePlayer
                    (
                      controller: controller,
                      showVideoProgressIndicator: true,

                    ),
                  ),

                  const SizedBox(height: 12),

                  // ANIME HIGHLIGHT
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row
                    (
                      children: [
                        
                        // ANIME IMAGE
                        ClipRRect
                        (
                          borderRadius: BorderRadius.circular(8),
                          child: Image
                          (
                            image: NetworkImage(detailAnimes!.data!.images['jpg']!.smallImageUrl),
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
        
                        const SizedBox(width: 12,),
        
                        // ANIME TITLE
                        Flexible
                        (
                          child: Column
                          (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                            [
                              Text
                              (
                                detailAnimes!.data!.title.toString(),
                                style: const TextStyle
                                (
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
        
                              const SizedBox(height: 12),
                    
                              // ANIME EPISODE & DURATION
                              Row
                              (
                                children: 
                                [
                                  Text
                                  (
                                    detailAnimes!.data!.episodes.toString(),
                                    style: const TextStyle
                                    (
                                      fontSize: 13,
                                      color: Colors.black54
                                    ),
                                  ),
                                  const Text
                                  (
                                    " Episodes - ",
                                    style: TextStyle
                                    (
                                      fontSize: 13,
                                      color: Colors.black54
                                    ),
                                  ),
                                  Text
                                  (
                                    detailAnimes!.data!.duration.toString(),
                                    style: const TextStyle
                                    (
                                      fontSize: 13,
                                      color: Colors.black54
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                listGenres.join(", "),
                                style: const TextStyle
                                    (
                                      fontSize: 13,
                                      color: Colors.black54
                                    ),
            
                              )
                            ],
                          ),
                        ),
        
                        const SizedBox(width: 8,),
        
                        // ANIME SCORE
                        Column
                        (
                          children: [
                            const Text
                            (
                              "Score",
                              style: TextStyle
                              (
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container
                            (
                              decoration: BoxDecoration
                              (
                                color: const Color.fromRGBO(231, 111, 81, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding
                              (
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: Text
                                (
                                  detailAnimes!.data!.score.toString(),
                                  style: const TextStyle
                                  (
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
        
                  DefaultTabController
                  (
                    length: 3,
                    child: Column
                    (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const TabBar
                        (
                          labelColor: Colors.black,
                          indicatorColor: Color.fromRGBO(231, 111, 81, 1),
                          labelStyle: TextStyle
                          (
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                          indicatorWeight: 4,
                          tabs: 
                          [
                          Tab(text: "Overview"),
                          Tab(text: "Information"),
                          Tab(text: "Review"),
                        ]),
                        
                        SizedBox
                        ( 
                          //Add this to give height
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView
                          (
                            children: [
                            Container
                            (
                              child: Padding
                              (
                                padding: const EdgeInsets.symmetric(vertical :16),
                                child: Text
                                (
                                  detailAnimes!.data!.synopsis.toString(),
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle
                                  (
                                    height: 1.5
                                  ),
                                ),
                              ),
                            ),
                            Container
                            (
                              child: Padding
                              (
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Column
                                (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // TYPE
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Type: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(detailAnimes!.data!.type.toString()),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // SOURCE
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Source: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(detailAnimes!.data!.source.toString()),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // STATUS
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Status: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(detailAnimes!.data!.status.toString()),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // RATING
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Rating: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(detailAnimes!.data!.rating.toString()),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // AIRED
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Aired: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(detailAnimes!.data!.aired.string.toString()),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // BROADCAST
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Broadcast: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text("${detailAnimes!.data!.season.toString()[0].toUpperCase()}${detailAnimes!.data!.season.toString().substring(1).toLowerCase()} ${detailAnimes!.data!.year.toString()}"),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // PRODUCERS
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text
                                        (
                                          "Producers: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Column
                                        (
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: listProducers
                                        )
                                        ,
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),
                                    
                                    // LISENCORS
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text
                                        (
                                          "Lisencors: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Column
                                        (
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: listLisencors
                                        )
                                        ,
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // DEMOGRAPHIC
                                    Row(
                                      children: [
                                        const Text
                                        (
                                          "Demographic: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(detailAnimes!.data!.demographics[0].name.toString()),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),

                                    // THEMES
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text
                                        (
                                          "Themes: ",
                                          style: TextStyle
                                          (
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Column
                                        (
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: listThemes
                                        )
                                        ,
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),
                                    
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(detailAnimes!.data!.trailer.url.toString()),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

