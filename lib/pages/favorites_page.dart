import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

final nameController = TextEditingController();
final ageController = TextEditingController();
final birthdayController = TextEditingController();

class _FavoritesPageState extends State<FavoritesPage> 
{
  
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: SafeArea
      (
        child: Container
        (
          padding: EdgeInsets.all(24),
          child: ListView
          (
            children: 
            <Widget> [
              TextField
              (
                controller: nameController,
                decoration: InputDecoration
                (
                  label: Text("Name")
                ),
              ),
              TextField
              (
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration
                (
                  label: Text("Age")
                ),
              ),
              TextField
              (
                controller: birthdayController,
                decoration: InputDecoration
                (
                  label: Text("Birthday")
                ),
              ),

              ElevatedButton
              (
                onPressed: () 
                {
                  final name = nameController.text;
                  final age = int.parse(ageController.text);
                  final birthday = birthdayController.text;
                  
                  // createUser(name: name, age: age, birthday: birthday);

                  Navigator.pop(context);
                },
                child: Text("Submit")
              )
            ],
          ),
        ) 
      ),
    );
  }

  // Stream <List<User>> readUsers() => FirebaseFirestore.instance
  // .collection("users")
  // .snapshots()
  // .map((snapshot) => 
  //     snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  //   Future createUser({required String name, required int age, required String birthday}) async 
  //   {
  //     final docUser = FirebaseFirestore.instance.collection("users").doc();

  //     final user = MyUser(
  //       id: docUser.id,
  //       name: name,
  //       age: age,
  //       birthday: DateTime(2000, 5, 2)
  //     );

  //     final json = user.toJson();

  //     await docUser.set(json);
  //   }
}

class MyUser 
{
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  MyUser(
    {
      this.id = '',
      required this.name,
      required this.age,
      required this.birthday
    }
  );

  Map <String, dynamic> toJson() => 
  {
    "id": id,
    "name": name,
    "age": age,
    "birthday": birthday
  };
}