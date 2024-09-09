import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/circular_avatar.dart';
import 'package:mal_clone/storage/storage.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({super.key, required this.user});

  final User? user;

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  File? file;

  Future uploadAndSync() async {
    String fileName = "${widget.user!.uid}_pic.${file!.path.split(".").last}";
    Uint8List fileToPass = file!.readAsBytesSync();
    await Storage().uploadImage(fileName, fileToPass);

    if (widget.user?.photoURL == null) {
      widget.user?.updatePhotoURL(fileName);
      widget.user?.reload();
    }

    await Storage().downloadImage(fileName);
  }

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
      body: Column(
        children: [
          GestureDetector(
              onTap: () async {
                final picture =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (picture != null) {
                  file = File(picture.path);
                  setState(() {});
                }
              },
              child: MyCircularAvatar(
                radius: 70,
                user: widget.user,
                newImage: file,
              )),
          ElevatedButton(
              onPressed: () async {
                if (file != null) {
                  uploadAndSync();
                  setState(() {});
                }
              },
              child: const Text("Upload")),
        ],
      ),
    );
  }
}
