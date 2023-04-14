import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/menu.dart';
import '../management/main_controller.dart';
import '../routes/routes.dart';

class MenuTabBar extends StatelessWidget {
  final Menu root;

  const MenuTabBar({super.key, required this.root});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: MainController.to.rootMenus
          .map((menu) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.5,
                        color: menu == root ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () =>
                        Get.offAndToNamed(Routes.menu, arguments: menu),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(children: [
                        Icon(menu.icon, color: Colors.white),
                        const SizedBox(height: 6.0),
                        Text(
                          menu.name,
                          style: const TextStyle(color: Colors.white),
                        )
                      ]),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
