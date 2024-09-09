import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/components/app_text_title.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({super.key, required this.user});

  final User? user;

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
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
    );
  }
}
