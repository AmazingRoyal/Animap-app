import 'package:animap/pages/auth/auth_page.dart';
import 'package:animap/pages/detail_anime_page.dart';
import 'package:animap/pages/favorites_page.dart';
import 'package:animap/pages/home_page.dart';
import 'package:animap/pages/profile_page.dart';
import 'package:animap/pages/result_page.dart';
import 'package:animap/pages/search_page.dart';
import 'package:animap/pages/auth/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MaterialApp(
    initialRoute: '/',
    routes: 
    {
      '/':(context) => const MyApp(),
      '/anime':((context) => DetailAnimePage(malId: '',)),
      '/search':((context) => ResultPage(query: '',)),
      '/favorites':(context) => FavoritesPage(),
    },
  ));
}

class MyApp extends StatefulWidget 
{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> 
{
  int _selectedIndex = 0;
  var screen = [
    HomePage(),
    FavoritesPage(),
    SearchPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      theme: ThemeData
      (
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(110, 68, 255, 1),
        colorScheme: const ColorScheme.light
        (
          primary: Color.fromRGBO(110, 68, 255, 1),
          secondary: Colors.black54,
          tertiary: Color.fromRGBO(38, 70, 83, 1)
        )
        
      ),
      home: Scaffold
      (
        body: StreamBuilder <User?> 
        (
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) 
          {
            if (snapshot.connectionState == ConnectionState.waiting)
            {
              return Center
              (
                child: CircularProgressIndicator()
              );
            } else if(snapshot.hasError){
              return Center
              (
                child: Text("Something went wrong"),
              );
            } else if (!snapshot.hasData && _selectedIndex == 3)
            {
              return AuthPage();
            } else if (snapshot.hasData && _selectedIndex == 3)
            {
              return VerifyEmailPage();
            } else 
            {
              return screen.elementAt(_selectedIndex);
            }
          },
        ),
        bottomNavigationBar: Container
        (
          decoration: BoxDecoration
          (
            color: Colors.white,
            boxShadow: [
              BoxShadow
              (
                blurRadius: 20,
                color: Colors.black.withOpacity(.1)
              )
            ]
          ),
          child: SafeArea
          (
            child: Padding
            (
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav
              (
                rippleColor: Colors.grey.shade300,
                hoverColor: Colors.grey.shade100,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: const Color.fromRGBO(110, 68, 255, 1),
                color: const Color.fromRGBO(38, 70, 83, 1),
                haptic: true,
                tabs: const [
                  GButton
                  (
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton
                  (
                    icon: Icons.today,
                    text: 'Schedule',
                  ),
                  GButton
                  (
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton
                  (
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) 
                {
                  setState(() 
                  {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}