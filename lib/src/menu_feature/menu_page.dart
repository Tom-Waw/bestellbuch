import 'package:bestellbuch/src/menu_feature/menu.dart';
import 'package:bestellbuch/src/menu_feature/menu_service.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../auth/auth_service.dart';
import 'menu_add_button.dart';
import 'menu_item_box.dart';
import 'menu_nav_controller.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Obx(() => MenuNavController.to.current?.isRoot ?? true
              ? const Text("Menu")
              : SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => MenuNavController.to.close(),
                      ),
                      Text(MenuNavController.to.current!.name),
                    ],
                  ),
                )),
          centerTitle: true,
          actions: [
            if (AuthService.to.isAdmin) ...[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => setState(() => _editMode = !_editMode),
              ),
              const MenuAddButton(),
            ]
          ],
          bottom: TabBar(
            controller: MenuNavController.to.controller,
            tabs: MenuService.to.menus
                .map((menu) => Tab(text: menu.name))
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: MenuNavController.to.controller,
          children: MenuService.to.menus
              .map((menu) => _buildMenuView(menu: menu))
              .toList(),
        )));
  }

  Widget _buildMenuView({required Menu menu}) {
    return menu.items.isNotEmpty
        ? GridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: menu.items
                .map((item) => MenuItemBox(item: item, editable: _editMode))
                .toList(),
          )
        : const Center(child: Text("Keine Daten vorhanden"));
  }
}
