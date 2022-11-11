import 'package:animap/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
{
  bool isEmailVerified = false;

  @override
  Widget build(BuildContext context) 
  {
    final user = FirebaseAuth.instance.currentUser!;

    return isEmailVerified ? HomePage() : Scaffold
    (
      appBar: AppBar
      (
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        centerTitle: true,
        title: Text
        (
          "Profile"
        ),
      ),
      body: SafeArea
      (
        child: Padding
        (
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              [
                Container(
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
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 45,
                    child: CircleAvatar
                    (
                      backgroundImage: NetworkImage
                      (
                        user.providerData[0].photoURL
                        ?? "https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png"
                      ),
                      radius: 40,
                    ),
                  ),
                ),

                SizedBox(height: 24,),

                Text
                (
                  user.email.toString(),
                  style: TextStyle
                  (
                    fontSize: 16
                  ),
                ),
                
                SizedBox(height: 32,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon
                    (
                      icon: Icon
                      (
                        Icons.favorite,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      label: Text
                      (
                        "Favorites",
                        style: TextStyle
                        (
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                      onPressed: null, 
                    ),
                  ],
                ),

                SizedBox(height: 8,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon
                    (
                      icon: Icon
                      (
                        Icons.dark_mode,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      label: Text
                      (
                        "Night Mode",
                        style: TextStyle
                        (
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                      onPressed: null, 
                    ),
                  ],
                ),

                SizedBox(height: 46,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon
                    (
                      icon: Icon
                      (
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      label: Text
                      (
                        "Sign Out",
                        style: TextStyle
                        (
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                      onPressed: FirebaseAuth.instance.signOut, 
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}