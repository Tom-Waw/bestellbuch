import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../shared/custom_bottom_sheet.dart';
import 'employee_form.dart';
import 'employee.dart';
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
            onPressed: () => Get.bottomSheet(
              _buildBottomSheet("Mitarbeiter hinzufügen"),
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: EmployeeService.to.employees.length,
            itemBuilder: (_, index) => EmployeeListItem(
              employee: EmployeeService.to.employees[index],
              buildBottomSheet: () => Get.bottomSheet(
                _buildBottomSheet(
                  "Mitarbeiter bearbeiten",
                  EmployeeService.to.employees[index],
                ),
                backgroundColor: Colors.white,
              ),
            ),
          )),
    );
  }

  Widget _buildBottomSheet(String title, [Employee? employee]) =>
      CustomBottomSheet(
        title: title,
        children: [EmployeeForm(employee: employee)],
      );
}
