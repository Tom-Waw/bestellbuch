import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import '../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentifizierung")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                autofocus: true,
                controller: _nameController,
                decoration: const InputDecoration(
                    label: Text("Name"),
                    prefixIcon: Icon(Icons.person_outline_rounded)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihren Namen ein.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    label: Text("Passwort"),
                    prefixIcon: Icon(Icons.fingerprint)),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihr Passwort ein.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? error = await AuthService.to.loginAsAdmin(
                      _nameController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    if (error != null) {
                      setState(() => _error = error);
                      return;
                    }

                    Get.offAllNamed(Routes.home);
                  }
                },
                child: const Text("Anmelden"),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
