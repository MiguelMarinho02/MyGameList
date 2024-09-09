import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/circular_avatar.dart';
import 'package:mal_clone/pages/user_pages/edit_profile.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key, required this.user});

  final User? user;

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
            const SizedBox(height: 50,),
            Row(
              children: [
                const SizedBox(width: 20,),
                MyCircularAvatar(radius: 60, user: user),
                const SizedBox(width: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user?.displayName ?? "null", 
                      style: GoogleFonts.archivoBlack(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Text(
                          user?.metadata.creationTime.toString().substring(0,10) ?? "null", 
                          style: GoogleFonts.archivoBlack(color: Colors.white, fontSize: 10),
                        ),
                        const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileEditor(user: user,))),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: GoogleFonts.archivoBlack(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Text("adddd shit ehre", style: TextStyle(color: Colors.white),)
          ],
        ));
  }
}
