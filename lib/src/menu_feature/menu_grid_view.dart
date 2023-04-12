import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_item_box.dart';
import '../management/main_controller.dart';

class MenuGridView extends StatelessWidget {
  const MenuGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.count(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: MainController.to.menu.items
            .map((item) => MenuItemBox(item: item))
            .toList()));
  }
}
