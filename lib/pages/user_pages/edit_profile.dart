import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/circular_avatar.dart';
import 'package:mal_clone/components/text_forms_auth.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
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
  bool isUploading = false;
  bool isUpdatingUsername = false;
  String message = "";
  final userNameController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future uploadAndSync() async {
    String fileName = "${user!.uid}_pic.${file!.path.split(".").last}";
    Uint8List fileToPass = file!.readAsBytesSync();
    await Storage().uploadImage(fileName, fileToPass);

    if (user?.photoURL == null) {
      await user!.updatePhotoURL(fileName);
    }

    await user!.reload();

    await Storage().downloadImage(fileName);
    message = "Photo changed successfully";
  }

  Future updateUsername() async {
    if (userNameController.text.trim().length > 10) {
      message = "Username must have 10 characters or less";
      return;
    }

    if (await FireStoreFunctions()
        .checkUsernameUniqueness(userNameController.text.trim())) {
      message = "Username is not Unique";
      return;
    }

    final usersRef = db.collection("users");
    await usersRef
        .doc(user!.uid)
        .update({"username": userNameController.text.trim()});
    await user!.updateDisplayName(userNameController.text.trim());

    await user!.reload();
    message = "Username changed successfully";
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
              GestureDetector(
                  onTap: () async {
                    final picture = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (file != null) {
                      setState(() {
                        isUploading = true;
                      });
                      await uploadAndSync();
                      if (!context.mounted) return;
                      final userProvider1 =
                          Provider.of<UserProvider>(context, listen: false);
                      await userProvider1.refreshUser();
                      setState(() {
                        isUploading = false;
                      });
                    }
                  },
                  child: !isUploading
                      ? const Text("Upload")
                      : const CircularProgressIndicator()),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                height: 70,
                child: MyTextFormAuth(
                    controller: userNameController,
                    hintText: "Username",
                    obscureText: false),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (userNameController.text.isNotEmpty) {
                      setState(() {
                        isUpdatingUsername = true;
                      });
                      await updateUsername();
                      if (!context.mounted) return;
                      final userProvider1 =
                          Provider.of<UserProvider>(context, listen: false);
                      await userProvider1.refreshUser();
                      setState(() {
                        isUpdatingUsername = false;
                        userNameController.clear();
                      });
                    }
                  },
                  child: !isUpdatingUsername
                      ? const Text("Update Username")
                      : const CircularProgressIndicator()),

              //add support for more changes
            ],
          ),
        ],
      ),
    );
  }
}
