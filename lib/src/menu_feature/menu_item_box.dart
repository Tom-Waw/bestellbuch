import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/main_controller.dart';
import '../routes/routes.dart';

class MenuItemBox extends StatelessWidget {
  final MenuItem item;

  const MenuItemBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        onTap: () => item is Menu
            ? Get.offAndToNamed(Routes.menu, arguments: item as Menu)
            : null,
        onLongPress: () => Get.defaultDialog(
          title: "Willst du dieses Element wirklich löschen?",
          titlePadding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          content: const SizedBox(height: 0.0),
          contentPadding: const EdgeInsets.only(bottom: 25.0),
          onConfirm: () {
            MainController.to.deleteFromMenu(item);
            Get.back();
          },
          buttonColor: Colors.red,
          confirmTextColor: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.name, textAlign: TextAlign.center),
            if (item is Product) ...[
              const SizedBox(height: 5),
              Text(
                "${(item as Product).price.toStringAsFixed(2)} €",
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
