import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mal_clone/storage/storage.dart';

class MyCircularAvatar extends StatefulWidget {
  const MyCircularAvatar({super.key, required this.radius, required this.user, this.newImage});

  final double radius;
  final User? user;
  final File? newImage;

  @override
  State<MyCircularAvatar> createState() => _MyCircularAvatarState();
}

class _MyCircularAvatarState extends State<MyCircularAvatar> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(widget.newImage != null){
          return CircleAvatar(
            radius: widget.radius,
            backgroundImage: FileImage(widget.newImage!),
          );
        }
        else if (widget.user?.photoURL == null) {
          return CircleAvatar(
            radius: widget.radius,
            backgroundImage: const AssetImage("assets/images/default_pic.jpg"),
          );
        } else {
          return FutureBuilder(
            future: Storage().getUserImagePath(widget.user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final filePath = snapshot.data!;
                  final file = File(filePath);
                  if (file.existsSync()) {
                    return CircleAvatar(
                      radius: widget.radius,
                      backgroundImage: FileImage(file),
                    );
                  } else {
                    return CircleAvatar(
                      radius: widget.radius,
                      backgroundImage:
                          const AssetImage("assets/images/default_pic.jpg"),
                    );
                  }
                } else {
                  return CircleAvatar(
                    radius: widget.radius,
                    backgroundImage:
                        const AssetImage("assets/images/default_pic.jpg"),
                  );
                }
              } else {
                //not done acessing the directory
                return CircleAvatar(
                  radius: widget.radius,
                  child: const CircularProgressIndicator(),
                );
              }
            },
          );
        }
      },
    );
  }
}
