import 'package:flutter/material.dart';

class MySearchResults extends StatelessWidget {
  const MySearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("results",style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}