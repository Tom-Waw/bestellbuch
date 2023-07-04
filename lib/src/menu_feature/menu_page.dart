import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../shared/utils.dart';
import 'menu_form.dart';
import 'menu_nav_controller.dart';
import 'menu_tabbar.dart';
import 'menu_view.dart';
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
                  icon: Icon(_editMode ? Icons.edit : Icons.edit_off),
                  color: _editMode ? Colors.white : Colors.grey[400],
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
            bottom: MenuTabBar(
              editable: _editMode,
              exitEditMode: () => setState(() => _editMode = false),
            ),
          ),
          body: MenuView(
            editMode: _editMode,
            exitEditMode: () => setState(() => _editMode = false),
          ),
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
