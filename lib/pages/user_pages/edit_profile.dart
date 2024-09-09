import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/circular_avatar.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/storage.dart';
import 'package:provider/provider.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({
    super.key,
  });

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  File? file;
  User? user;

  Future uploadAndSync() async {
    String fileName = "${user!.uid}_pic.${file!.path.split(".").last}";
    Uint8List fileToPass = file!.readAsBytesSync();
    await Storage().uploadImage(fileName, fileToPass);

    if (user?.photoURL == null) {
      await user!.updatePhotoURL(fileName);
    }

    await user!.reload();

    await Storage().downloadImage(fileName);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
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
                user: user,
                newImage: file,
              )),
          ElevatedButton(
              onPressed: () async {
                if (file != null) {
                  await uploadAndSync();
                  if (!context.mounted) return;
                  final userProvider1 =
                      Provider.of<UserProvider>(context, listen: false);
                  await userProvider1.refreshUser();
                  setState(() {});
                }
              },
              child: const Text("Upload")),
        ],
      ),
    );
  }
}
