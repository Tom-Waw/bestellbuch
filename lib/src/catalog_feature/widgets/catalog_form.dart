import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../catalog.dart';
import '../catalog_controller.dart';

class CatalogForm extends StatefulWidget {
  const CatalogForm({super.key});

  @override
  State<CatalogForm> createState() => _CatalogFormState();
}

class _CatalogFormState extends State<CatalogForm> {
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
                  CatalogController.to.add(
                    Catalog(_nameController.text, []),
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
