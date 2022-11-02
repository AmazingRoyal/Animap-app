import 'package:animap/models/season_now.dart';
import 'package:animap/models/top_anime.dart';
import 'package:animap/services/remote_service.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as log_dev;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TopAnime? topAnimes;
  SeasonNow? seasonNows;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getTopAnime();
    getSeasonNow();
  }

  getTopAnime() async{
    topAnimes = await RemoteService().getTopAnime();

    if (topAnimes != null) {
      setState(() {
        isLoaded = true;
      });
      log_dev.log("topAnimes?.data![0].images.toString()");
      log_dev.log(topAnimes!.data![0].images['jpg']!.imageUrl.toString());
    }
  }

  getSeasonNow() async{
    seasonNows = await RemoteService().getSeasonNow();

    if (seasonNows != null) {
      setState(() {
        isLoaded = true;
      });
      log_dev.log("topAnimes?.data![0].images.toString()");
      log_dev.log(seasonNows!.data[0].images['jpg']!.imageUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "ANIMAP",
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "TOP ANIME",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: isLoaded,
                // ignore: sort_child_properties_last
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topAnimes?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
                      child: Container(
                        width: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 16,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image(
                                  image: NetworkImage(topAnimes!.data![index].images['jpg']!.imageUrl),
                                  height: 180,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // ANIME TITLE
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                topAnimes!.data![index].title.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),

                            // ANIME SCORE
                            Row(
                              children: [
                                const Text(
                                  "Score",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(127, 87, 227, 1),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    child: Text(
                                      topAnimes!.data![index].score.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Text(
                                  topAnimes!.data![index].episodes.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54
                                  ),
                                ),
                                const Text(
                                  " Eps - ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54
                                  ),
                                ),
                                Text(
                                  topAnimes!.data![index].duration.toString().replaceAll(" per ep", ""),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                }),
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}