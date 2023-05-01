import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/main_controller.dart';

class MenuForm extends StatefulWidget {
  const MenuForm({super.key});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Gruppennamen eingeben",
            ),
            controller: _nameController,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Bitte geben Sie einen Namen an";
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  MainController.to.addToMenu(
                    Menu(name: _nameController.text, items: []),
                  );
                  Get.back();
                }
              },
              child: const Text("Bestätigen"),
            ),
          ),
        ],
      ),
    );
  }
}
