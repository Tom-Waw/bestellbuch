import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/employee_service.dart';
import '../shared/utils.dart';
import 'employee.dart';
import 'employee_form.dart';
import 'employee_group_form.dart';
import 'employee_list_item.dart';

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
              "Gruppe hinzufügen",
              const EmployeeGroupForm(),
            ),
          )
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: EmployeeService.to.groups.length,
            itemBuilder: (_, index) =>
                _buildGroupTile(EmployeeService.to.groups[index]),
          )),
    );
  }

  Widget _buildGroupTile(EmployeeGroup group) => Card(
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(14.0),
          title: Text(
            group.name,
            style: const TextStyle(fontSize: 18.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Utils.showBottomSheet(
                  "Mitarbeiter hinzufügen",
                  EmployeeForm(group: group),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Utils.showBottomSheet(
                  "Gruppe anpassen",
                  EmployeeGroupForm(group: group),
                ),
              ),
            ],
          ),
          children: [
            const Divider(thickness: 2.0),
            if (group.employees.isEmpty)
              const ListTile(title: Text("Keine Mitarbeiter vorhanden")),
            ...group.employees.map(
              (e) => EmployeeListItem(employee: e),
            )
          ],
        ),
      );
}
