import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/table_service.dart';
import '../shared/add_delete_buttons.dart';
import '../shared/form_error_message.dart';
import '../shared/utils.dart';
import 'table.dart';

class TableForm extends StatefulWidget {
  final TableGroup? group;

  const TableForm({super.key, this.group});

  @override
  State<TableForm> createState() => _TableFormState();
}

class _TableFormState extends State<TableForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late int _size;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.name);
    _size = widget.group?.tables.length ?? 0;
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
          const SizedBox(height: 20.0),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    padding: const EdgeInsets.all(20.0),
                    onPressed: () => setState(() => _size++),
                    icon: const Icon(Icons.add),
                  ),
                  Expanded(
                    child: Center(
                        child: Text(
                      _size.toString(),
                      style: const TextStyle(fontSize: 24.0),
                    )),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(20.0),
                    onPressed: () => setState(() => _size == 0 ? 0 : _size--),
                    icon: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ),
          if (_error != null) FormErrorMessage(text: _error!),
          AddDeleteButtons(
            onAdd: _onAdd,
            onDelete: _onDelete,
            deleteText: widget.group == null ? "Abbrechen" : "Löschen",
          ),
        ],
      ),
    );
  }

  void _onDelete() async {
    if (widget.group == null) return Get.back();

    String? error;

    await Utils.showConfirmDialog(
      "Möchten Sie die Tischgruppe mit allen Tischen wirklich löschen?",
      () async {
        error = await TableService.to.deleteGroup(widget.group);
      },
    );

    if (error != null) return setState(() => _error = error);

    Get.back();
  }

  void _onAdd() async {
    if (!_formKey.currentState!.validate()) return;

    String? error;

    if (widget.group != null) {
      widget.group?.name = _nameController.text;
      error = await TableService.to.updateGroup(_size, widget.group!);
    } else {
      error = await TableService.to.addGroup(
        name: _nameController.text,
        size: _size,
      );
    }

    if (error != null) return setState(() => _error = error);

    Get.back();
  }
}
