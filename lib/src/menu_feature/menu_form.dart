import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/add_delete_buttons.dart';
import '../shared/form_error_message.dart';
import '../shared/utils.dart';
import 'menu.dart';
import 'menu_nav_controller.dart';
import '../services/menu_service.dart';

class MenuForm extends StatefulWidget {
  final Menu? menu;

  const MenuForm({super.key, this.menu});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menu?.name);
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
          AddDeleteButtons(
            onAdd: _onAdd,
            onDelete: _onDelete,
            deleteText: widget.menu == null ? "Abbrechen" : "Löschen",
          )
        ],
      ),
    );
  }

  void _onDelete() async {
    if (widget.menu == null) return Get.back();

    String? error;

    await Utils.showConfirmDialog(
      "Möchten Sie das Menü mit allen Inhalten wirklich löschen?",
      () async {
        error = await MenuService.to.deleteItem(widget.menu!);
      },
    );

    if (error != null) return setState(() => _error = error);

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

    if (error != null) return setState(() => _error = error);

    Get.back();
  }
}
