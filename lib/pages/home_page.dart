import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/drawer.dart';
import 'package:mal_clone/pages/main_pages/game_list.dart';
import 'package:mal_clone/pages/main_pages/home.dart';
import 'package:mal_clone/pages/main_pages/search.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.user});

  final User? user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 13, 13, 14),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const MyBarText(
          text: "MGL",
          size: 35,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(
        user: widget.user,
      ),
      body:<Widget>[
        MyHome(),
        MySearch(),
        MyList(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: Colors.white)
          )
        ),
        child: NavigationBar(
          backgroundColor: const Color.fromARGB(255, 42, 42, 42),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Theme.of(context).colorScheme.primary,
          selectedIndex: currentPageIndex,
          destinations: const<Widget>[
            NavigationDestination(
              icon: Icon(Icons.home, color: Colors.white,),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search, color: Colors.white,),
              label: 'Search'
            ),
            NavigationDestination(
              icon: Icon(Icons.list_rounded, color: Colors.white,),
              label: 'My List'
            ),
          ]
        ),  
      ), 
    );
  }
}