import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'employees_controller.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mitarbeiter")),
      body: Obx(() => ListView.builder(
            itemCount: EmployeesController.to.employees.length,
            itemBuilder: (_, index) {
              final employee = EmployeesController.to.employees[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14.0),
                  title: Text(employee, style: const TextStyle(fontSize: 18.0)),
                ),
              );
            },
          )),
    );
  }
}
