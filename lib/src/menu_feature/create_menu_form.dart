import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_service.dart';

class CreateMenuForm extends StatefulWidget {
  const CreateMenuForm({super.key});

  @override
  State<CreateMenuForm> createState() => _CreateMenuFormState();
}

class _CreateMenuFormState extends State<CreateMenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            autofocus: true,
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
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await MenuService.to.addItem({
                  "name": _nameController.text,
                });
                Get.back();
              }
            },
            child: const Text("Bestätigen"),
          ),
        ],
      ),
    );
  }
}
