import 'package:bestellbuch/src/employees_feature/employee.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'employee_service.dart';

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
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
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

                if (error != null) {
                  setState(() => _error = error);
                  return;
                }

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