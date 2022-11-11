// ignore_for_file: must_be_immutable

import 'package:animap/models/search_anime.dart';
import 'package:animap/pages/detail_anime_page.dart';
import 'package:animap/services/remote_service.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget 
{
  ResultPage({ super.key, required this.query });

  String query = "";

  @override
  // _ResultPageState createState() => _ResultPageState();
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  SearchAnime? resultAnimes;
  var isLoaded = false;

  @override
  void initState() 
  {
    // FETCH DATA FROM API
    getResultAnime(widget.query);

    super.initState();
  }

  getResultAnime(var query) async
  {
    resultAnimes = await RemoteService(query: query).getSearchAnime();

    if (resultAnimes != null) 
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
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text(widget.query),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea
      (
        child: Center(
          child: Padding
          (
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: NotificationListener<OverscrollIndicatorNotification>
                  (
                    onNotification: (overScroll)
                    {
                      overScroll.disallowIndicator();
                      return false;
                    },
              child: GridView.builder
              (
                itemCount: resultAnimes!.data!.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent
                (
                  maxCrossAxisExtent: 180,
                  mainAxisExtent: 280,
                  childAspectRatio: 3/2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20
                ),
                itemBuilder: (context, index) {
                  return Container
                  (
                    alignment: Alignment.center,
                    child: InkWell
                    (
                      onTap: () 
                      {
                        Navigator.push
                        (
                          context,
                          MaterialPageRoute
                          (
                            builder: (context) => DetailAnimePage(malId: resultAnimes!.data![index].malId.toString()),
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
                            Container
                            (
                              decoration: BoxDecoration
                              (
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                boxShadow: 
                                [
                                  BoxShadow
                                  (
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 16,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              ),
                    
                              // TOP ANIME CONTENT - IMAGE
                              child: ClipRRect
                              (
                                borderRadius: BorderRadius.circular(16),
                                child: Image
                                (
                                  image: NetworkImage(resultAnimes!.data![index].images['jpg']!.imageUrl),
                                  height: 180,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        
                            // TOP ANIME CONTENT - TITLE
                            Padding
                            (
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                resultAnimes!.data![index].title.toString(),
                                maxLines: 2,
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
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Padding
                                  (
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    child: Text
                                    (
                                      resultAnimes!.data![index].score.toString(),
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
                                  resultAnimes!.data![index].episodes.toString(),
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
                                  resultAnimes!.data![index].duration.toString().replaceAll(" per ep", ""),
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
                },
              ),
            ),
          ),
        )
      ),
    );
  }
}