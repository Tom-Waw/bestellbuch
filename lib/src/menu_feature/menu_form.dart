import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/form_error_message.dart';
import '../shared/utils.dart';
import 'menu.dart';
import 'menu_nav_controller.dart';
import 'menu_service.dart';

class MenuForm extends StatefulWidget {
  final Menu? menu;

  const MenuForm({super.key, this.menu});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menu?.name ?? "";
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
                    widget.menu == null ? "Abbrechen" : "Löschen",
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
    if (widget.menu != null) {
      await Utils.showConfirmDialog(
        "Möchten Sie das Menü mit allen Inhalten wirklich löschen?",
        () async => await MenuService.to.deleteItem(widget.menu!),
      );
    }

    Get.back();
  }

  void _onAdd() async {
    if (!_formKey.currentState!.validate()) return;

    String? error;

    if (widget.menu != null) {
      widget.menu!.name = _nameController.text;
      error = await MenuService.to.updateItem(widget.menu!);
    } else {
      error = await MenuService.to.addMenu(
        parent: MenuNavController.to.current!,
        name: _nameController.text,
      );
    }

    if (error != null) {
      setState(() => _error = error);
      return;
    }

    Get.back();
  }
}
