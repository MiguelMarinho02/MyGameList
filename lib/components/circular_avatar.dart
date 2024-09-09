import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mal_clone/storage/storage.dart';

class MyCircularAvatar extends StatelessWidget {
  const MyCircularAvatar({super.key, required this.radius, required this.user});

  final double radius;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (user?.photoURL == null) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: const AssetImage("assets/images/default_pic.jpg"),
          );
        } else {
          return FutureBuilder(
            future: Storage().getUserImagePath(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final filePath = snapshot.data!;
                  final file = File(filePath);
                  if (file.existsSync()) {
                    return CircleAvatar(
                      radius: radius,
                      backgroundImage: FileImage(file),
                    );
                  } else {
                    return CircleAvatar(
                      radius: radius,
                      backgroundImage:
                          const AssetImage("assets/images/default_pic.jpg"),
                    );
                  }
                } else {
                  return CircleAvatar(
                    radius: radius,
                    backgroundImage:
                        const AssetImage("assets/images/default_pic.jpg"),
                  );
                }
              } else {
                //not done acessing the directory
                return CircleAvatar(
                  radius: radius,
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
