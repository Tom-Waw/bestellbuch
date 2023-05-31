import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/menu_controller.dart';
import '../management/order_controller.dart';

class MenuItemBox extends StatelessWidget {
  final MenuItem item;
  final bool enabled;

  const MenuItemBox({super.key, required this.item, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        onTap: enabled
            ? () {
                if (item is Menu) {
                  MenuController.to.openMenu(item as Menu);
                } else if (Get.isRegistered<OrderController>()) {
                  Get.back(result: item as Product);
                }
              }
            : null,
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
