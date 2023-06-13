import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../shared/utils.dart';
import 'employee_form.dart';
import 'employee_list_item.dart';
import 'employee_service.dart';

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
            icon: const Icon(FontAwesomeIcons.plus),
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
