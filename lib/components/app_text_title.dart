import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBarText extends StatelessWidget {
  final String text;
  final double size;
  const MyBarText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nerkoOne(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: size,
      ),
    );
  }
}
