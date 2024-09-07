import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_clone/components/button_login_register.dart';
import 'package:mal_clone/pages/auth/welcome.dart';
import 'package:mal_clone/pages/user_pages/profile.dart';
import 'package:mal_clone/storage/storage.dart';

class MyDrawer extends StatelessWidget {
  final User? user;

  const MyDrawer({
    super.key,
    required this.user,
  });

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 42, 42, 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MyProfile(user: user,))),
                child: Row(
                  //avatar andd basic info
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    Builder(
                      builder: (context) {
                        if (user?.photoURL == null) {
                          return const CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage("assets/images/default_pic.jpg"),
                          );
                        } else {
                          return FutureBuilder(
                            future: Storage().getUserImagePath(user),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  final filePath = snapshot.data!;
                                  final file = File(filePath);
                                  if (file.existsSync()) {
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundImage: FileImage(file),
                                    );
                                  } else {
                                    return const CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                          "assets/images/default_pic.jpg"),
                                    );
                                  }
                                } else {
                                  return const CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                        "assets/images/default_pic.jpg"),
                                  );
                                }
                              } else {
                                //not done acessing the directory
                                return const CircleAvatar(
                                  radius: 25,
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      //Profile name and profile link
                      children: [
                        Text(
                          user?.displayName ?? "Error",
                          style: GoogleFonts.archivoBlack(
                              color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Profile",
                          style: GoogleFonts.archivoBlack(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
          Column(
            children: [
              const Divider(),
              MyButtonAuth(
                  text: "Logout",
                  onTap: () async {
                    await logOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyWelcomePage()),
                        (route) => false);
                  },
                  isSigning: false),
            ],
          )
        ],
      ),
    );
  }
}
