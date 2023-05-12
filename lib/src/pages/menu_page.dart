import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../management/menu_controller.dart';

import '../menu_feature/menu_add_button.dart';
import '../menu_feature/menu_item_box.dart';
import '../menu_feature/menu_tabbar.dart';

/// Displays the menu that is managed by the admin.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(MenuController.to.menu.isRoot
                ? "Menu"
                : MenuController.to.menu.name),
            bottom: const MenuTabBar(),
            actions: const [MenuAddButton()],
          ),
          body: GridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: MenuController.to.menu.items
                .map((item) => MenuItemBox(item: item))
                .toList(),
          ),
        ));
  }
}
