import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/add_delete_buttons.dart';
import '../shared/form_error_message.dart';
import '../services/employee_service.dart';
import '../shared/utils.dart';
import 'employee.dart';

class EmployeeForm extends StatefulWidget {
  final Employee? employee;

  const EmployeeForm({super.key, this.employee});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
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
              hintText: "Namen eingeben",
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
            deleteText: widget.employee == null ? "Abbrechen" : "Löschen",
          ),
        ],
      ),
    );
  }

  void _onDelete() async {
    if (widget.employee == null) return Get.back();

    String? error;

    await Utils.showConfirmDialog(
      "Willst du diesen Benutzer wirklich löschen?",
      () async {
        error = await EmployeeService.to.deleteEmployee(widget.employee!);
      },
    );

    if (error != null) return setState(() => _error = error);

    Get.back();
  }

  void _onAdd() async {
    if (!_formKey.currentState!.validate()) return;

    String? error;

    if (widget.employee != null) {
      widget.employee?.name = _nameController.text;
      error = await EmployeeService.to.updateEmployee(widget.employee!);
    } else {
      error = await EmployeeService.to.addEmployee(
        name: _nameController.text,
      );
    }

    if (error != null) return setState(() => _error = error);

    Get.back();
  }
}
