import 'package:animap/pages/detail_anime_page.dart';
import 'package:animap/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/':(context) => const MyApp(),
    '/anime':((context) => const DetailAnimePage(malId: '',))
  }
));


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  int _selectedIndex = 0;
  final screen = [
    const HomePage(),
    const DetailAnimePage(malId: '',),
    const HomePage(),
    const HomePage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: screen.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1)
              )
            ]
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey.shade300,
                hoverColor: Colors.grey.shade100,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: const Color.fromRGBO(231, 111, 81, 1),
                color: const Color.fromRGBO(38, 70, 83, 1),
                haptic: true,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Setting',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
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