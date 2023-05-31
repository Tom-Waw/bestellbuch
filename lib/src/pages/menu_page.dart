import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';

import '../auth/auth_service.dart';
import '../data/menu.dart';
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
            centerTitle: true,
            bottom: const MenuTabBar(),
            actions: [
              if (AuthService.to.isAdmin.value) ...[
                IconButton(
                    onPressed: () => MenuController.to.toggleEdit(),
                    icon: const Icon(Icons.brush)),
                const MenuAddButton(),
              ]
            ],
          ),
          body: GridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: MenuController.to.menu.items
                .map(
                  (item) => MenuController.to.isEditing.value
                      ? _editableWrapper(
                          MenuItemBox(
                            item: item,
                            enabled: false,
                          ),
                        )
                      : MenuItemBox(item: item),
                )
                .toList(),
          ),
        ));
  }

  Widget _editableWrapper(MenuItemBox child) {
    return ShakeWidget(
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
            MenuController.to.deleteFromMenu(child.item);
            Get.back();
          },
          buttonColor: Colors.red,
          confirmTextColor: Colors.white,
        ),
        child: Ink(child: child),
      ),
    );
  }
}
