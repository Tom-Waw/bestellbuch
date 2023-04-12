import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/main_controller.dart';
import '../menu_feature/menu_dialog.dart';
import '../menu_feature/menu_grid_view.dart';
import '../menu_feature/menu_tabbar.dart';

/// Displays the menu that is managed by the admin.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainController.to.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text("Menu"),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: MenuTabBar(),
              ),
            ),
            body: const MenuGridView(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                children: [
                  if (!MainController.to.rootMenus
                      .contains(MainController.to.menu))
                    FloatingActionButton(
                      onPressed: () => MainController.to.back(),
                      child: const Icon(Icons.arrow_back),
                    ),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () => Get.dialog(const MenuDialog()),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ));
  }
}
