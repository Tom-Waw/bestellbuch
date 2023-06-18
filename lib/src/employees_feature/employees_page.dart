import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/utils.dart';
import 'employee_form.dart';
import 'employee_list_item.dart';
import '../services/employee_service.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mitarbeiter"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Utils.showBottomSheet(
              "Mitarbeiter hinzufügen",
              const EmployeeForm(),
            ),
          )
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: EmployeeService.to.employees.length,
            itemBuilder: (_, index) => EmployeeListItem(
              employee: EmployeeService.to.employees[index],
            ),
          )),
    );
  }
}
