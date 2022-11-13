// ignore_for_file: must_be_immutable

import 'package:animap/models/anime_characters.dart';
import 'package:animap/models/detail_anime.dart';
import 'package:animap/pages/person_voice_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/favorites.dart';
import '../services/remote_service.dart';

import 'dart:developer' as log_dev;

class DetailAnimePage extends StatefulWidget 
{
  DetailAnimePage({super.key, required this.malId});

  String malId="";

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> 
{ 
  DetailAnime? detailAnimes;
  AnimeCharacters? animeCharacters;

  var isLoadedDetailAnime = false;
  var isLoadedAnimeCharacters = false;
  double gapSpace = 8.0;
  bool checkDir = false;
  
  List<Widget> listProducers = <Widget>[];
  List<Widget> listLisencors = <Widget>[];
  List<String> listGenres = <String>[];
  List<Widget> listThemes = <Widget>[];

  @override
  void initState() 
  {
    setState(() 
      {
        isLoadedDetailAnime = false;
        isLoadedAnimeCharacters = false;
      });

    // FETCH DATA FROM API
    getDetailAnime(widget.malId);
    getAnimeCharacters(widget.malId);

    super.initState();
  }

  getDetailAnime(var malId) async
  {
    detailAnimes = await RemoteService(malId: malId).getDetailAnime();

    if (detailAnimes != null) 
    {
      setState(() 
      {
        isLoadedDetailAnime = true;
      });
    }
  }

  getAnimeCharacters(var malId) async
  {
    animeCharacters = await RemoteService(malId: malId).getAnimeCharacters();
    log_dev.log(animeCharacters!.data![0].character.name.toString());

    if (detailAnimes != null) 
    {
      setState(() 
      {
        isLoadedAnimeCharacters = true;
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

    for(int i=0; i<detailAnimes!.data!.producers.length;i++)
    {
      listProducers.add
      (
        Text(detailAnimes!.data!.producers[i].name.toString())
      );
    }

    for(int i=0; i<detailAnimes!.data!.licensors.length;i++)
    {
      listLisencors.add
      (
        Text(detailAnimes!.data!.licensors[i].name.toString())
      );
    }

    for(int i=0; i<detailAnimes!.data!.genres.length;i++)
    {
      listGenres.add
      (
        detailAnimes!.data!.genres[i].name.toString()
      );
    }

    for(int i=0; i<detailAnimes!.data!.themes.length;i++)
    {
      listThemes.add
      (
        Text(detailAnimes!.data!.themes[i].name.toString())
      );
    }

    YoutubePlayerController controller = YoutubePlayerController(
        initialVideoId: detailAnimes!.data!.trailer.youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
        ),
    );

    return Scaffold
    (
      appBar: AppBar
      (
        title: Text
        (
          "Anime Overview",
          style: TextStyle
          (
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea
      (
        child: SingleChildScrollView
        (
          child: Visibility
          (
            visible: true,
            replacement: const Center
            (
              child: CircularProgressIndicator(),
            ),
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              [
                YoutubePlayer
                (
                  controller: controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Theme.of(context).primaryColor,
                ),
                    
                // ANIME HIGHLIGHT
                StickyHeader
                (
                  header: Container
                  (
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    color: Colors.white,
                    child: Row
                    (
                      children: [
                        
                        // ANIME IMAGE
                        ClipRRect
                        (
                          borderRadius: BorderRadius.circular(8),
                          child: Image
                          (
                            image: NetworkImage(detailAnimes!.data!.images['jpg']!.imageUrl),
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
                      
                              const SizedBox(height: 4,),
                      
                              Text(
                                listGenres.join(", "),
                                style: const TextStyle
                                (
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                        
                              )
                            ],
                          ),
                        ),
                    
                        const SizedBox(width: 8,),
                    
                        // ANIME SCORE
                        Column
                        (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20)
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
                            ),
                            IconButton
                            (
                              icon: Icon(Icons.star_border), 
                              color: Theme.of(context).colorScheme.tertiary,
                              iconSize: 36,
                              onPressed:() {
                                log_dev.log("like");
                                final mal_id = int.parse(detailAnimes!.data!.malId.toString());
                                final title = detailAnimes!.data!.title;
                                final image = detailAnimes!.data!.images['jpg']!.imageUrl;
                                final score = detailAnimes!.data!.score;
                                final type = detailAnimes!.data!.type;
                                final episode = detailAnimes!.data!.episodes;
                                final duration = detailAnimes!.data!.duration;
                                
                                createFavorite
                                (
                                  mal_id: mal_id, 
                                  title: title,
                                  image: image, 
                                  score: score,
                                  type: type, 
                                  episode: episode,
                                  duration: duration, 
                                );
                              }, 
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  content: DefaultTabController
                  (
                    length: 3,
                    child: Column
                    (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TabBar
                        (
                          labelColor: Colors.black,
                          indicatorColor: Theme.of(context).primaryColor,
                          labelStyle: const TextStyle
                          (
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                          indicatorWeight: 4,
                          tabs: 
                          const [
                          Tab(text: "Overview"),
                          Tab(text: "Information"),
                          Tab(text: "Characters"),
                        ]),
                        
                        SizedBox
                        ( 
                          //Add this to give height
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView
                          (
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                            Container
                            (
                              child: Padding
                              (
                                padding: const EdgeInsets.symmetric(horizontal:24, vertical :16),
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
                                padding: const EdgeInsets.symmetric(horizontal:24, vertical: 16),
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
                                    Row
                                    (
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),
                      
                                    // LISENCORS
                                    Row
                                    (
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),
                      
                                    // THEMES
                                    Row
                                    (
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: gapSpace),
                                  ],
                                ),
                              ),
                            ),
                            Container
                            (
                              child: NotificationListener<OverscrollIndicatorNotification>
                              (
                                onNotification: (overScroll)
                                {
                                  overScroll.disallowIndicator();
                                  return false;
                                },
                                child: ListView.builder
                                (
                                  // physics: const ClampingScrollPhysics(),
                                  itemCount: animeCharacters!.data!.length < 20 ? animeCharacters!.data!.length : 20,
                                  itemBuilder: (context, index) 
                                  {
                                    var japan = 0;

                                    if(animeCharacters!.data![index].voiceActors.length > 0)
                                    {
                                      for (int i=0 ; i<animeCharacters!.data![index].voiceActors.length ; i++) 
                                      {
                                        if (animeCharacters!.data![index].voiceActors[i].language.toString() == "Japanese"){
                                          japan = i;
                                          break;
                                        }else if (i == animeCharacters!.data![index].voiceActors.length -1){
                                          japan = i;
                                        }
                                      }
                                    }else{
                                      japan = -1;
                                    }

                                    return Padding
                                    (
                                      padding: const EdgeInsets.symmetric(horizontal:24,vertical: 8),
                                      child: Row
                                      (
                                        children: 
                                        [
                                          ClipRRect
                                          (
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image
                                            (
                                              image: NetworkImage(animeCharacters!.data![index].character.images['jpg']!.imageUrl),
                                              height: 100,
                                              width: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 12),
                              
                                          Expanded
                                          (
                                            child: Column
                                            (
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column
                                                (
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: 
                                                  [
                                                    Text
                                                    (
                                                      animeCharacters!.data![index].character.name.toString(),
                                                      style: const TextStyle
                                                      (
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    
                                                    Text
                                                    (
                                                      animeCharacters!.data![index].role.toString(),
                                                      style: TextStyle
                                                      (
                                                        fontWeight: animeCharacters!.data![index].role=="Main" ? FontWeight.bold : FontWeight.normal,
                                                        color: animeCharacters!.data![index].role=="Main" ? Theme.of(context).primaryColor : Colors.black
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column
                                                (
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: 
                                                  [
                                                    Text
                                                    (
                                                      japan < 0 ? "?" : animeCharacters!.data![index].voiceActors[japan].person.name.toString(),
                                                      style: const TextStyle
                                                      (
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    Text(japan < 0 ? "?" : animeCharacters!.data![index].voiceActors[japan].language.toString()),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 12),
                              
                                          InkWell(
                                            onTap: () {
                                              Navigator.push
                                              (
                                                context,
                                                MaterialPageRoute
                                                (
                                                  builder: (context) => PersonVoicePage
                                                  (
                                                    malId: japan < 0 ? "" : animeCharacters!.data![index].voiceActors[japan].person.malId.toString(),
                                                    imageUrl: japan < 0 ? "" : animeCharacters!.data![index].voiceActors[japan].person.images.jpg.imageUrl.toString(),
                                                    name: japan < 0 ? "" : animeCharacters!.data![index].voiceActors[japan].person.name.toString(),
                                                    language: japan < 0 ? "" : animeCharacters!.data![index].voiceActors[japan].language.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect
                                            (
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image
                                              (
                                                image: NetworkImage(japan < 0 
                                                ? "https://i.pinimg.com/736x/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg" 
                                                : animeCharacters!.data![index].voiceActors[japan].person.images.jpg.imageUrl),
                                                height: 100,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                ),
                              )
                            ),
                          ]),
                        ),
                      ],
                    ),
                  )
                ),
                SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended
      (
        onPressed: () {
          
        },
        label: Text
        (
          "Add to Favorite",
          style: TextStyle
          (
            color: Colors.white
          ),
        ),
        icon: Icon
        (
          Icons.thumb_up,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future createFavorite(
    {
      required int mal_id, 
      required String title,
      required String image,
      required num score,
      required String type,
      required int episode,
      required String duration,
    }
  ) async 
  {
    final docFavorite = FirebaseFirestore.instance.collection("favorites").doc(userId).collection("data").doc(mal_id.toString());

    final favorite = Favorites(
      mal_id: mal_id,
      title: title,
      image: image,
      score: score,
      type: type,
      episode: episode,
      duration: duration,
    );

    final json = favorite.toJson();
    await docFavorite.set(json);
  }
}

