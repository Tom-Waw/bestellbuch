import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getPages
            .sublist(1)
            .map((p) => Expanded(
                  child: InkWell(
                    onTap: () => Get.toNamed(p.name),
                    child: Center(
                      child: Text(
                        p.name.substring(1).capitalize!,
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
