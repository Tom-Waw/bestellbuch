import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_form.dart';
import '../auth/auth_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AuthService.to.isReady.value
        ? Scaffold(
            appBar: AppBar(title: const Text("Authentifizierung")),
            body: const Padding(
              padding: EdgeInsets.all(12.0),
              child: AuthForm(),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ));
  }
}
