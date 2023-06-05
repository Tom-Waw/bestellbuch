import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'menu_controller.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produkt anlegen")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Artikelnamen eingeben",
                ),
                controller: _nameController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Bitte geben Sie einen Namen an";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Preis",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                controller: _priceController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Bitte geben Sie einen Preis an";
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
                      "price": double.parse(_priceController.text),
                    });
                    Get.back();
                  }
                },
                child: const Text(
                  "Bestätigen",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
