import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/state_service.dart';
import '../routes/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => StateService.to.isLoading.value
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Routes.menu, Routes.tables]
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
          ));
  }
}
