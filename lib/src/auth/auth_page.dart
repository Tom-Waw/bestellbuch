import 'package:flutter/material.dart';

import 'auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentifizierung")),
      body: Form(
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
                  label: Text("Passwort"), prefixIcon: Icon(Icons.fingerprint)),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AuthService.to.loginAsAdmin(
                    _nameController.text.trim(),
                    _passwordController.text.trim(),
                  );
                }
              },
              child: const Text("Anmelden"),
            )
          ],
        ),
      ),
    );
  }
}
