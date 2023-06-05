import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../auth/auth_service.dart';

import 'menu.dart';
import 'menu_add_button.dart';
import 'menu_controller.dart';
import 'menu_item_box.dart';
import 'menu_tabbar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _editMode = false;
  Menu menu = MenuController.to.menu;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(menu.isRoot ? "Menu" : menu.name),
            centerTitle: true,
            bottom: const MenuTabBar(),
            actions: AuthService.to.isAdmin
                ? [
                    IconButton(
                      onPressed: () => setState(() {
                        _editMode = !_editMode;
                      }),
                      icon: const Icon(Icons.brush),
                    ),
                    const MenuAddButton(),
                  ]
                : null,
          ),
          body: GridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: menu.items
                .map((item) => MenuItemBox(item: item, editable: _editMode))
                .toList(),
          ),
        ));
  }
}
