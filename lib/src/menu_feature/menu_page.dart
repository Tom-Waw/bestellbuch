import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../shared/utils.dart';
import '../services/menu_service.dart';
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
            title: Obx(() => !MenuNavController.to.canClose
                ? const Text("Menü")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => MenuNavController.to.close(),
                        icon: const Icon(Icons.keyboard_arrow_up),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          MenuNavController.to.current!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                  icon: const Icon(Icons.add),
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
                  children: MenuNavController.to.current!.items
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
