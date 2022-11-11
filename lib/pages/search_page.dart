// ignore_for_file: library_private_types_in_public_api

import 'package:animap/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:input_history_text_field/input_history_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController queryController = TextEditingController();
  late String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text
        (
          "Browse Anime",
          style: TextStyle
          (
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent
      ),
      body: SafeArea
      (
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column
          (
            children: 
            [
              Form
              (
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:4,
                      child: InputHistoryTextField
                      (
                        historyKey: "01",
                        onChanged: (value) => text = value,
                        decoration: InputDecoration
                        (
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            
                          ),
                          hintText: "Search Anime and more..."
                        ), 
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton
                      (
                        style: ElevatedButton.styleFrom
                        (
                          minimumSize: const Size.fromHeight(60)
                        ),
                        onPressed: () {
                          if(text != "")
                          {
                            Navigator.push
                            (
                              context, MaterialPageRoute
                              (
                                builder: (context) => ResultPage(query: text),
                              ),
                            );
                          }
                        },
                        child: const Icon(Icons.search)
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}