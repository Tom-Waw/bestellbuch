import 'package:bestellbuch/src/menu_feature/menu_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/main_controller.dart';
import '../menu_feature/menu_item_box.dart';

/// Displays the menu that is managed by the admin.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainController.to.isLoading.value
        ? Scaffold(
            appBar: AppBar(title: const Text("Menu")),
            body: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: const MenuAppBar(),
            body: GridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: MainController.to.menu.items
                  .map((item) => MenuItemBox(item: item))
                  .toList(),
            ),
          ));
  }
}
