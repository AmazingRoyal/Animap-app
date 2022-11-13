// ignore_for_file: must_be_immutable

import 'package:animap/models/person_voices.dart';
import 'package:animap/services/remote_service.dart';
import "package:flutter/material.dart";

class PersonVoicePage extends StatefulWidget {
  PersonVoicePage
  ({
    super.key, 
    required this.malId, 
    required this.imageUrl, 
    required this.name, 
    required this.language
  });

  String malId = "";
  String imageUrl = "";
  String name = "";
  String language = "";

  @override
  _PersonVoicePageState createState() => _PersonVoicePageState();
}

class _PersonVoicePageState extends State<PersonVoicePage> 
{
  PersonVoices? personVoices;
  var isLoaded = false;

  @override
  void initState() {
    getPersonVoices(widget.malId);

    super.initState();
  }

  getPersonVoices(var malId) async
  {
    personVoices = await RemoteService(malId: malId).getPersonVoices();

    if (personVoices != null)
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
        title: Text("Voice Actor"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea
      (
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>
          [
            Expanded
            (
              flex: 1,
              child: Padding
              (
                padding: const EdgeInsets.all(12.0),
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect
                    (
                      borderRadius: BorderRadius.circular(8),
                      child: Image
                      (
                        image: NetworkImage(widget.imageUrl),
                        // height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 24,),
                    Column
                    (mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text
                        (
                          widget.name,
                          style: TextStyle
                          (
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        Text
                        (
                          widget.language,
                          style: TextStyle
                          (
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 36,),
                        ElevatedButton.icon
                        (
                          icon: Icon(Icons.thumb_up_alt), 
                          label: Text("Add to Favorite"),
                          onPressed:() {
                            
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded
            (
              flex: 2,
              child: GridView.builder
              (
                itemCount: personVoices?.data.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent
                (
                  maxCrossAxisExtent: 140,
                  mainAxisExtent: 200,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4
                ),
                itemBuilder:(context, index) 
                {
                  return Container
                  (
                    decoration: BoxDecoration
                    (
                      image: DecorationImage
                      (
                        image: NetworkImage(personVoices!.data[index].character.images['jpg']!.imageUrl.toString()),
                        fit: BoxFit.cover,
                      )
                    ),
                    child: Column
                    (
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration
                            (
                              gradient: LinearGradient
                              (
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black, Colors.transparent]
                              )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text
                                (
                                  personVoices!.data[index].character.name.toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle
                                  (
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),

                                Text
                                (
                                  personVoices!.data[index].anime.title.toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle
                                  (
                                    color: Colors.white,
                                    fontSize: 13
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}