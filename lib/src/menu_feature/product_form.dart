import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../shared/add_delete_buttons.dart';
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

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _priceController =
        TextEditingController(text: widget.product?.price.toString());
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
          AddDeleteButtons(
            onAdd: _onAdd,
            onDelete: _onDelete,
            deleteText: widget.product == null ? "Abbrechen" : "Löschen",
          )
        ],
      ),
    );
  }

  void _onDelete() {
    if (widget.product == null) {
      Get.back();
      return;
    }

    Utils.showConfirmDialog(
      "Möchten Sie den Artikel wirklich löschen?",
      () async => await MenuService.to.deleteItem(widget.product!),
    );
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
