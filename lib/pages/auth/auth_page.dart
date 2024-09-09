import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mal_clone/pages/auth/welcome.dart';
import 'package:mal_clone/pages/home_page.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/storage.dart';
import 'package:provider/provider.dart';

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
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (user?.photoURL != null) {
                await Storage().downloadImage(user!.photoURL!);
              }
              if (!context.mounted) return;
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.setUser(user);
            });
            return const MyHomePage();
          } else {
            return const MyWelcomePage();
          }
        },
      ),
    );
  }
}
