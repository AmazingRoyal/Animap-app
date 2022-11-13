import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

final mal_idController = TextEditingController();
final titleController = TextEditingController();
final imageController = TextEditingController();
final scoreController = TextEditingController();
final typeController = TextEditingController();
final episodeController = TextEditingController();
final durationController = TextEditingController();

class _FavoritesPageState extends State<FavoritesPage> 
{
   late final String documentId;
  
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: StreamBuilder
      (
        stream: readFavorites(),
        builder: (context, snapshot)
        {
          if (snapshot.hasData)
          {
            final favorites = snapshot.data!;
            return SafeArea
            (
              child: 
              Column
              (
                children: [
                  Expanded(
                    child: Container
                    (
                      padding: EdgeInsets.all(24),
                      child: ListView
                      (
                        children: 
                        <Widget> [
                          TextField
                          (
                            controller: mal_idController,
                            decoration: InputDecoration
                            (
                              label: Text("mal_id")
                            ),
                          ),
                          TextField
                          (
                            controller:titleController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration
                            (
                              label: Text("title")
                            ),
                          ),
                          TextField
                          (
                            controller: imageController,
                            decoration: InputDecoration
                            (
                              label: Text("image")
                            ),
                          ),
                          TextField
                          (
                            controller: scoreController,
                            decoration: InputDecoration
                            (
                              label: Text("score")
                            ),
                          ),
                          TextField
                          (
                            controller: typeController,
                            decoration: InputDecoration
                            (
                              label: Text("type")
                            ),
                          ),
                          TextField
                          (
                            controller: episodeController,
                            decoration: InputDecoration
                            (
                              label: Text("episode")
                            ),
                          ),
                          TextField
                          (
                            controller: durationController,
                            decoration: InputDecoration
                            (
                              label: Text("duration")
                            ),
                          ),
                            
                          ElevatedButton
                          (
                            onPressed: () 
                            {
                              final mal_id = int.parse(mal_idController.text);
                              final title = titleController.text;
                              final image = imageController.text;
                              final score = double.parse(scoreController.text);
                              final type = typeController.text;
                              final episode = int.parse(episodeController.text);
                              final duration = durationController.text;
                              
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
                            child: Text("Submit")
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView
                    (
                      children: favorites.map(buildFavorite).toList(),
                    ),
                  )
                ],
              ) 
            );
          }else if(snapshot.hasError) {
            return Text("Error");
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      )
    );

  }
    Widget buildFavorite(Favorites favorites) => ListTile
    (
      leading: CircleAvatar(child: Text("${favorites.episode}"),),
      title: Text(favorites.title),
      subtitle: Text(favorites.type),
      onTap: () {
        FirebaseFirestore.instance.collection("favorites").doc(userId).collection("data").doc(favorites.mal_id.toString()).delete().then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
      },
    );

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Stream <List<Favorites>> readFavorites() => FirebaseFirestore.instance
  .collection("favorites").doc(userId).collection("data")
  .snapshots()
  .map((snapshot) => 
      snapshot.docs.map((doc) => Favorites.fromJson(doc.data())).toList());

  Future createFavorite(
    {
      required int mal_id, 
      required String title,
      required String image,
      required double score,
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

class Favorites 
{
  final int mal_id;
  final String title;
  final String image;
  final double score;
  final String type;
  final int episode;
  final String duration;

  Favorites(
    {
      required this.mal_id,
      required this.title,
      required this.image,
      required this.score,
      required this.type,
      required this.episode,
      required this.duration,
    }
  );

  Map <String, dynamic> toJson() => 
  {
    "mal_id": mal_id,
    "title": title,
    "image": image,
    "score": score,
    "type": type,
    "episode": episode,
    "duration": duration,
  };

  static Favorites fromJson(Map <String, dynamic> json) => Favorites
  (
    mal_id: json['mal_id'],
    title: json['title'],
    image: json['image'],
    score: json['score'],
    type: json['type'],
    episode: json['episode'],
    duration: json['duration'],
  );

}