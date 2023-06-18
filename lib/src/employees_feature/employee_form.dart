import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/form_error_message.dart';
import '../services/employee_service.dart';
import 'employee.dart';

class EmployeeForm extends StatefulWidget {
  final Employee? employee;

  const EmployeeForm({super.key, this.employee});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.employee?.name ?? "";
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
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? error;

                if (widget.employee != null) {
                  widget.employee!.name = _nameController.text;
                  error =
                      await EmployeeService.to.updateEmployee(widget.employee!);
                } else {
                  error = await EmployeeService.to.addEmployee(
                    name: _nameController.text,
                  );
                }

                if (error != null) return setState(() => _error = error);

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
    );
  }
}
