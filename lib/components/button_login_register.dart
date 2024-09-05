import 'package:flutter/material.dart';

class MyButtonAuth extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool isSigning;

  const MyButtonAuth({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSigning,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: isSigning ? const CircularProgressIndicator(color: Colors.black,) : Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
