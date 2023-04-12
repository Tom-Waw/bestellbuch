import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/main_controller.dart';

class MenuTabBar extends StatelessWidget {
  const MenuTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: MainController.to.rootMenus
              .map((menu) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.5,
                            color: menu == MainController.to.menu
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => MainController.to.selectMenu(menu),
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
        ));
  }
}
