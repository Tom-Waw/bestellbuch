import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/main_controller.dart';
import '../menu_feature/menu_dialog.dart';
import '../menu_feature/menu_grid_view.dart';
import '../menu_feature/menu_tabbar.dart';

/// Displays the menu that is managed by the admin.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (MainController.to.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      Menu menu = MainController.to.menu;
      return Scaffold(
        appBar: AppBar(
          title: Text(menu == menu.getRoot() ? "Menu" : menu.name),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: MenuTabBar(),
          ),
        ),
        body: const MenuGridView(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              if (menu != menu.getRoot())
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () => MainController.to.closeMenu(),
                  child: const Icon(Icons.arrow_back),
                ),
              const Spacer(),
              FloatingActionButton(
                heroTag: null,
                onPressed: () => Get.dialog(const MenuDialog()),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      );
    });
  }
}
