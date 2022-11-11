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
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea
      (
        child: Center
        (
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Expanded
              (
                flex: 1,
                child: Column
                (
                  children: [
                    Padding
                    (
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container
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
                        child: ClipRRect
                        (
                          borderRadius: BorderRadius.circular(8),
                          child: Image
                          (
                            image: NetworkImage(widget.imageUrl),
                            height: 140,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

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
                  ],
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
                    mainAxisExtent: 180,
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2
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
      ),
    );
  }
}