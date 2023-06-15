import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import 'auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService.to.logout(),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Routes.employees, Routes.menu, Routes.tables]
            .map((route) => Expanded(
                  child: InkWell(
                    onTap: () => Get.toNamed(route),
                    child: Center(
                      child: Text(
                        route.substring(1).capitalize!,
                        textScaleFactor: 2,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
