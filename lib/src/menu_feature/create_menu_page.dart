import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../management/menu_controller.dart';

class CreateMenuPage extends StatefulWidget {
  const CreateMenuPage({super.key});

  @override
  State<CreateMenuPage> createState() => _CreateMenuPageState();
}

class _CreateMenuPageState extends State<CreateMenuPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu erstellen")),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 25.0),
          child: Form(
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
                const SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await MenuController.to.addItem({
                        "name": _nameController.text,
                      });
                      Get.back();
                    }
                  },
                  child: const Text("Bestätigen"),
                ),
              ],
            ),
          )),
    );
  }
}
