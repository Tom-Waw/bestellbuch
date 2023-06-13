import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../employees_feature/employee_service.dart';
import '../routes.dart';
import 'auth_page.dart';
import 'auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentifizierung")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() => ListView.builder(
              itemCount: 1 + EmployeeService.to.employees.length,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return _buildLoginTile(
                    "Admin",
                    () => Get.to(() => const AuthPage()),
                    Icons.lock,
                  );
                }

                final employee = EmployeeService.to.employees[index - 1];
                return _buildLoginTile(employee.name, () {
                  AuthService.to.loginAsEmployee(employee);
                  Get.offAllNamed(Routes.tables);
                });
              },
            )),
      ),
    );
  }

  Widget _buildLoginTile(String title, VoidCallback onTap, [IconData? icon]) {
    return ListTile(
      title: Text(title),
      trailing: icon != null ? const Icon(Icons.lock) : null,
      onTap: onTap,
    );
  }
}
