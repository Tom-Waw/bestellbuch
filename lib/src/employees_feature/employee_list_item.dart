import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../shared/utils.dart';
import 'employee.dart';
import 'employee_form.dart';
import '../services/employee_service.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee employee;

  const EmployeeListItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        key: ValueKey(employee.name),
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            label: "Löschen",
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            onPressed: (_) => Utils.showConfirmDialog(
                "Willst du diesen Benutzer wirklich löschen?",
                () => EmployeeService.to.deleteEmployee(employee)),
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
}
