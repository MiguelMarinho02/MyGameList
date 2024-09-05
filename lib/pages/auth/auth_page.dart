import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mal_clone/pages/auth/welcome.dart';
import 'package:mal_clone/pages/home_page.dart';
import 'package:mal_clone/storage/storage.dart';

class MyAuthPage extends StatelessWidget {
  const MyAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user?.photoURL != null) {
              Storage().downloadImage(user?.photoURL);
            }
            return MyHomePage(
              user: user,
            );
          } else {
            return const MyWelcomePage();
          }
        },
      ),
    );
  }
}
