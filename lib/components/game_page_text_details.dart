import 'package:flutter/material.dart';

class MyFieldGamePage extends StatelessWidget {
  const MyFieldGamePage(
      {super.key,
      required this.fieldName,
      required this.fieldContent,
      required this.crossAxisAlignment,
      this.fontSizeContent = 25,
      this.fontSizeName = 15});

  final String fieldName;
  final String fieldContent;
  final CrossAxisAlignment crossAxisAlignment;
  final double fontSizeContent;
  final double fontSizeName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          fieldName,
          style: TextStyle(color: Colors.grey, fontSize: fontSizeName),
        ),
        Text(
          fieldContent,
          style: TextStyle(color: Colors.white, fontSize: fontSizeContent),
        ),
      ],
    );
  }
}
