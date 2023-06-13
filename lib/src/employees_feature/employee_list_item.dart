import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../shared/utils.dart';
import 'employee.dart';
import 'employee_form.dart';
import 'employee_service.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee employee;

  const EmployeeListItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            label: "Löschen",
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            onPressed: (_) => _showDeleteDialog(),
          ),
          SlidableAction(
            label: "Bearbeiten",
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            onPressed: (_) => Utils.showBottomSheet(
              "Mitarbeiter bearbeiten",
              EmployeeForm(
                employee: employee,
              ),
            ),
          ),
        ]),
        child: ListTile(
          contentPadding: const EdgeInsets.all(14.0),
          title: Text(
            employee.name,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: "Willst du diesen Benutzer wirklich löschen?",
      titlePadding: const EdgeInsets.all(25.0).copyWith(bottom: 0.0),
      content: const SizedBox.shrink(),
      contentPadding: const EdgeInsets.all(25.0),
      onConfirm: () {
        EmployeeService.to.deleteEmployee(employee);
        Get.back();
      },
      buttonColor: Colors.red,
      confirmTextColor: Colors.white,
    );
  }
}
