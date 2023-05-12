import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/menu_controller.dart';
import '../management/order_controller.dart';

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
        onTap: () {
          if (item is Menu) {
            MenuController.to.openMenu(item as Menu);
          } else if (Get.isRegistered<OrderController>()) {
            Get.back(result: item as Product);
          }
        },
        onLongPress: () => Get.defaultDialog(
          title: "Willst du dieses Element wirklich löschen?",
          titlePadding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          content: const SizedBox(height: 0.0),
          contentPadding: const EdgeInsets.only(bottom: 20.0),
          onConfirm: () {
            MenuController.to.deleteFromMenu(item);
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
              const SizedBox(height: 8.0),
              Text(
                (item as Product).price.toStringAsFixed(2),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
