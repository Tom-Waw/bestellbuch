import 'package:bestellbuch/src/menu_feature/menu.dart';
import 'package:bestellbuch/src/menu_feature/menu_service.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../auth/auth_service.dart';
import '../shared/utils.dart';
import 'menu_form.dart';
import 'menu_item_box.dart';
import 'menu_nav_controller.dart';
import 'product_form.dart';

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
                ? const Text("Menü")
                : SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!(MenuNavController.to.current?.isRoot ?? false))
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
                  color: _editMode ? Colors.red : Colors.white,
                  onPressed: () => setState(() => _editMode = !_editMode),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.plus),
                  onPressed: () => Utils.showBottomSheet(
                    "Menü erweitern",
                    _buildBottomSheetTabBarView(),
                  ),
                )
              ]
            ],
            bottom: TabBar(
              controller: MenuNavController.to.controller,
              tabs: MenuService.to.menus
                  .map((menu) => Tab(text: menu.name))
                  .toList(),
            ),
          ),
          body: Obx(() => MenuNavController.to.current?.items.isEmpty ?? true
              ? const Center(child: Text("Keine Daten vorhanden"))
              : GridView.count(
                  padding: const EdgeInsets.all(8.0),
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  children: _sortItems(MenuNavController.to.current!.items)
                      .map((item) => MenuItemBox(
                            item: item,
                            editable: _editMode,
                            exitEditMode: () =>
                                setState(() => _editMode = false),
                          ))
                      .toList(),
                )),
        ));
  }

  List<MenuItem> _sortItems(List<MenuItem> items) {
    int sort(MenuItem a, MenuItem b) => a.name.compareTo(b.name);

    List<Menu> menus = items.whereType<Menu>().toList();
    List<Product> products = items.whereType<Product>().toList();

    return [
      ...menus..sort(sort),
      ...products..sort(sort),
    ];
  }

  Widget _buildBottomSheetTabBarView() {
    return const DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Produkt"),
              Tab(text: "Menü"),
            ],
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: TabBarView(
              children: [
                ProductForm(),
                MenuForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
