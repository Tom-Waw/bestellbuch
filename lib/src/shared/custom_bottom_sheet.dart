import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomBottomSheet(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 18.0)),
          ...children.expand((child) =>
              [const SizedBox(height: 20.0), Expanded(child: child)]),
        ],
      ),
    );
  }
}
