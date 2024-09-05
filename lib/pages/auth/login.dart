import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/components/button_login_register.dart';
import 'package:mal_clone/components/text_forms_auth.dart';
import 'package:mal_clone/pages/home_page.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyLoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  User? user;

  bool isSigning = false;

  String? errorMessage;

  void updateErrorMessage(String message) {
    setState(() {
      clearControllers();
      errorMessage = message;
    });
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  Future logInUser() async {
    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      updateErrorMessage("Some fields were not filled");
      return;
    }

    setState(() {
      isSigning = true;
    });

    try {
      UserCredential userCredentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      user = userCredentials.user;
      clearControllers();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-credential') {
        updateErrorMessage("Wrong credentials");
      } else if (e.code == 'invalid-email') {
        updateErrorMessage("Selected email is invalid");
      } else if (e.code == 'user-disabled') {
        updateErrorMessage("This user was disabled");
      } else if (e.code == 'user-not-found') {
        updateErrorMessage("Could not find specified user");
      } else if (e.code == 'invalid-credential') {
        updateErrorMessage("Invalid credential");
      } else {
        updateErrorMessage(e.code);
      }
    } catch (e) {
      updateErrorMessage("Something went wrong, try again.");
    } finally {
      setState(() {
        isSigning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 104, 239),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 104, 239),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              if (errorMessage != null) {
                return Text(errorMessage.toString());
              } else {
                return Container();
              }
            }),
            MyTextFormAuth(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            MyTextFormAuth(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            MyButtonAuth(
              text: "Log In",
              isSigning: isSigning,
              onTap: () async {
                await logInUser();
                if (user != null) {
                  if (!context.mounted) return;
                  errorMessage = null;
                  Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (context) => MyHomePage(user: user,)),
                      (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
