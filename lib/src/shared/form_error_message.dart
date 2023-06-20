import 'package:flutter/material.dart';

class FormErrorMessage extends StatelessWidget {
  final String text;

  const FormErrorMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
