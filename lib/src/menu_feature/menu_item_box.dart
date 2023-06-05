import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';

import '../routes.dart';
import 'menu.dart';
import 'menu_controller.dart';
import '../order_feature/order_controller.dart';

class MenuItemBox extends StatelessWidget {
  final MenuItem item;
  final bool editable;

  const MenuItemBox({super.key, required this.item, this.editable = false});

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        onTap: !editable
            ? () => item is Menu
                ? Get.offNamed(Routes.menu, arguments: item)
                : Get.isRegistered<OrderController>()
                    ? Get.back(result: item)
                    : null
            : null,
        child: Ink(
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
      ),
    );

    return editable
        ? ShakeWidget(
            duration: const Duration(milliseconds: 2500),
            autoPlay: true,
            shakeConstant: ShakeLittleConstant1(),
            child: InkWell(
              onTap: () => Get.defaultDialog(
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
              child: Ink(child: widget),
            ),
          )
        : widget;
  }
}
