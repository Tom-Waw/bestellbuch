import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../routes.dart';
import 'menu_controller.dart';

class MenuTabBar extends StatelessWidget implements PreferredSizeWidget {
  const MenuTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: MenuController.to.menus
          .map((menu) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.5,
                        color: menu == MenuController.to.menu.getRoot()
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => Get.offNamed(Routes.menu, arguments: menu),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                          child: Text(
                        menu.name,
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
