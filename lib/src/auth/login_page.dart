import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import '../services/auth_service.dart';
import '../services/employee_service.dart';
import 'auth_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentifizierung")),
      body: Obx(() => ListView.builder(
            itemCount: 1 + EmployeeService.to.allEmployees.length,
            itemBuilder: (_, index) {
              if (index == 0) {
                return _buildLoginTile(
                  "Admin",
                  () => Get.to(() => const AuthPage()),
                  Icons.lock,
                );
              }

              final employee = EmployeeService.to.allEmployees[index - 1];
              return _buildLoginTile(employee.name, () {
                AuthService.to.loginAsEmployee(employee);
                Get.offAllNamed(Routes.tables);
              });
            },
          )),
    );
  }

  Widget _buildLoginTile(String title, VoidCallback onTap, [IconData? icon]) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14.0),
        title: Text(title, style: const TextStyle(fontSize: 18.0)),
        trailing: icon != null ? const Icon(Icons.lock) : null,
        onTap: onTap,
      ),
    );
  }
}
