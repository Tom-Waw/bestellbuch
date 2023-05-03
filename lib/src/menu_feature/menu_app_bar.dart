import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../management/main_controller.dart';
import 'create_menu_page.dart';
import 'create_product_page.dart';
import 'menu_tabbar.dart';

class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MenuAppBar({super.key});

  @override
  State<MenuAppBar> createState() => _MenuAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40.0);
}

class _MenuAppBarState extends State<MenuAppBar> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBar(
          title: Text(MainController.to.menu.isRoot
              ? "Menu"
              : MainController.to.menu.name),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: MenuTabBar(),
          ),
          actions: [
            if (!MainController.to.isLoading.value)
              IconButton(
                icon: const Icon(FontAwesomeIcons.plus),
                onPressed: () => Get.defaultDialog(
                  titlePadding: const EdgeInsets.symmetric(vertical: 22.0),
                  title: "Menu erweitern",
                  content: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(() => const CreateProductPage());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text("Produkt", textAlign: TextAlign.center),
                        ),
                      ),
                      const Divider(thickness: 1.5),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(() => const CreateMenuPage());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child:
                              Text("Gruppierung", textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ));
  }
}
