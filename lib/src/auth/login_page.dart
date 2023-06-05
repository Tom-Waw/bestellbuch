import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../employees_feature/employees_controller.dart';
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
        child: ListView.builder(
          itemCount: 1 + EmployeesController.to.employees.length,
          itemBuilder: (_, index) {
            if (index == 0) return _buildAdminLogin();

            final employee = EmployeesController.to.employees[index - 1];
            return ListTile(
              title: Text(employee),
              onTap: () {
                AuthService.to.loginAsEmployee(employee);
                Get.offAllNamed(Routes.tables);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdminLogin() {
    return ListTile(
      title: const Text("Admin"),
      onTap: () => Get.to(() => const AuthPage()),
    );
  }
}
