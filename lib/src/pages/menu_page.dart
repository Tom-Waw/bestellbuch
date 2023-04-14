import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/main_controller.dart';
import '../menu_feature/menu_dialog.dart';
import '../menu_feature/menu_grid_view.dart';
import '../menu_feature/menu_tabbar.dart';
import '../routes/routes.dart';

/// Displays the menu that is managed by the admin.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (MainController.to.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      Menu menu = Get.arguments ?? MainController.to.rootMenus.first;
      Menu root = menu.getRoot()!;

      return Scaffold(
        appBar: AppBar(
          title: Text(menu == root ? "Menu" : menu.name),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: MenuTabBar(root: root),
          ),
        ),
        body: MenuGridView(menu: menu),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              if (menu != root)
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () =>
                      Get.offAndToNamed(Routes.menu, arguments: menu.parent),
                  child: const Icon(Icons.arrow_back),
                ),
              const Spacer(),
              FloatingActionButton(
                heroTag: null,
                onPressed: () => Get.dialog(MenuDialog(menu: menu)),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      );
    });
  }
}
