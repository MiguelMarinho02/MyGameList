import 'package:flutter/material.dart';

class MyDateForm extends StatelessWidget {
  const MyDateForm(
      {super.key,
      required this.controller,
      required this.datePicker,
      required this.text,
      required this.finished});

  final TextEditingController controller;
  final Function datePicker;
  final String text;
  final bool finished;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: text,
          filled: true,
          prefixIcon: const Icon(Icons.calendar_month_outlined),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 10, 6, 231)))),
      readOnly: true,
      onTap: () {
        datePicker(finished);
      },
    );
  }
}
