import 'package:flutter/material.dart';

class AddDeleteButtons extends StatelessWidget {
  final void Function() onAdd;
  final void Function() onDelete;

  final String addText;
  final String deleteText;

  const AddDeleteButtons({
    super.key,
    required this.onAdd,
    required this.onDelete,
    this.addText = "Bestätigen",
    this.deleteText = "Löschen",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(deleteText, style: const TextStyle(fontSize: 16.0)),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: ElevatedButton(
            onPressed: onAdd,
            child: Text(addText, style: const TextStyle(fontSize: 16.0)),
          ),
        ),
      ],
    );
  }
}
