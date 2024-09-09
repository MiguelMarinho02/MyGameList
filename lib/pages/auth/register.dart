import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/components/button_login_register.dart';
import 'package:mal_clone/components/text_forms_auth.dart';
import 'package:mal_clone/pages/home_page.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyRegisterPage extends StatefulWidget {
  MyRegisterPage({super.key});

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordRepeatController = TextEditingController();

  final db = FirebaseFirestore.instance;

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
    passwordRepeatController.clear();
    usernameController.clear();
  }

  Future registerUser() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty) {
      updateErrorMessage("Some fields were not filled");
      return;
    }

    setState(() {
      isSigning = true;
    });

    if (matchPassword()) {
      try {
        UserCredential userCredentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (userCredentials.user != null) {
          user = userCredentials.user;

          await user?.updateDisplayName(usernameController.text.trim());

          await user!.reload();
          user = FirebaseAuth.instance.currentUser;

          //adds nothing for now but creates document for specific user
          Map<String, dynamic> data = {};
          db.collection("users").doc(user?.uid).set(data);
        }
        clearControllers();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          updateErrorMessage("Password is too weak");
        } else if (e.code == 'email-already-in-use') {
          updateErrorMessage("Selected email is already in use");
        } else if (e.code == 'invalid-email') {
          updateErrorMessage("Invalid email format");
        }
      } catch (e) {
        updateErrorMessage("Something went wrong, try again.");
      } finally {
        setState(() {
          isSigning = false;
        });
      }
    } else {
      updateErrorMessage("Passwords do not Match");
      setState(() {
        isSigning = false;
      });
    }
  }

  bool matchPassword() {
    if (passwordController.text.trim() ==
        passwordRepeatController.text.trim()) {
      return true;
    }
    return false;
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
              controller: usernameController,
              hintText: "Username",
              obscureText: false,
            ),
            MyTextFormAuth(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            MyTextFormAuth(
              controller: passwordRepeatController,
              hintText: "Repeat Password",
              obscureText: true,
            ),
            MyButtonAuth(
              text: "Register",
              isSigning: isSigning,
              onTap: () async {
                await registerUser();
                if (user != null) {
                  if (!context.mounted) return;
                  errorMessage = null;
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  userProvider.setUser(user);
                  Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (context) =>const MyHomePage()),
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
