import 'package:flutter/material.dart';

import '../shared/utils.dart';
import 'employee.dart';
import 'employee_form.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee employee;

  const EmployeeListItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14.0),
        title: Text(
          employee.name,
          style: const TextStyle(fontSize: 18.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (employee.isActive) const Icon(Icons.table_bar),
            IconButton(
              onPressed: () => Utils.showBottomSheet(
                "Mitarbeiter bearbeiten",
                EmployeeForm(employee: employee),
              ),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
