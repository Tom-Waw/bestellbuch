import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../shared/form_error_message.dart';
import '../shared/utils.dart';
import 'menu.dart';
import 'menu_nav_controller.dart';
import 'menu_service.dart';

class ProductForm extends StatefulWidget {
  final Product? product;

  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product?.name ?? "";
    _priceController.text = widget.product?.price.toString() ?? "";
  }

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
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
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
          const Spacer(),
          if (_error != null) FormErrorMessage(text: _error!),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    widget.product == null ? "Abbrechen" : "Löschen",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onAdd,
                  child: const Text(
                    "Bestätigen",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onDelete() async {
    if (widget.product != null) {
      await Utils.showConfirmDialog(
        "Möchten Sie den Artikel wirklich löschen?",
        () async => await MenuService.to.deleteItem(widget.product!),
      );
    }

    Get.back();
  }

  void _onAdd() async {
    if (!_formKey.currentState!.validate()) return;

    String? error;

    if (widget.product != null) {
      widget.product!.name = _nameController.text;
      widget.product!.price = double.parse(_priceController.text);
      error = await MenuService.to.updateItem(widget.product!);
    } else {
      error = await MenuService.to.addProductTo(
        menu: MenuNavController.to.current!,
        name: _nameController.text,
        price: double.parse(_priceController.text),
      );
    }

    if (error != null) {
      setState(() => _error = error);
      return;
    }

    Get.back();
  }
}
