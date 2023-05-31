import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import 'auth_service.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String?> _login() => AuthService.to.loginWithNameAndPassword(
        _nameController.text.trim(),
        _passwordController.text.trim(),
      );

  Future<String?> _register() => AuthService.to.createUserWithNameAndPassword(
        _nameController.text.trim(),
        _passwordController.text.trim(),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    label: Text("Name"),
                    prefixIcon: Icon(Icons.person_outline_rounded)),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    label: Text("Passwort"),
                    prefixIcon: Icon(Icons.fingerprint)),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? error = await _login();

                    if (error != null) {
                      Get.showSnackbar(GetSnackBar(
                        message: error.toString(),
                      ));
                      return;
                    }

                    if (AuthService.to.isAdmin.value) {
                      Get.offAllNamed(Routes.home);
                    } else {
                      Get.offAllNamed(Routes.tables);
                    }
                  }
                },
                child: Text(
                    AuthService.to.isAdmin.value ? "Registrieren" : "Anmelden"),
              )
            ],
          ),
        ));
  }
}
