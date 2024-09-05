import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/drawer.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({super.key, required this.user});

  final User? user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const MyBarText(
          text: "MGL",
          size: 35,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(user: widget.user,),
      backgroundColor: const Color.fromARGB(242, 13, 13, 14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "lol",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
