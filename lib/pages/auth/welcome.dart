import 'package:flutter/material.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/pages/auth/login.dart';
import 'package:mal_clone/pages/auth/register.dart';

class MyWelcomePage extends StatelessWidget {
  const MyWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 104, 239),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin:const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const FittedBox(
                child: MyBarText(text: "Welcome to MyGameList", size: 40)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyRegisterPage()));
                    },
                    child: const Text("Register")
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
                    },
                    child: const Text("Login")
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}