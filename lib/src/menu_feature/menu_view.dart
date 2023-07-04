import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_item_box.dart';
import 'menu_nav_controller.dart';

class MenuView extends StatelessWidget {
  final bool editMode;
  final void Function()? exitEditMode;

  const MenuView({super.key, this.editMode = false, this.exitEditMode});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MenuNavController.to.current?.items.isEmpty ?? true
        ? const Center(child: Text("Keine Daten vorhanden"))
        : GridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: MenuNavController.to.current!.items
                .map((item) => MenuItemBox(
                      item: item,
                      editable: editMode,
                      exitEditMode: exitEditMode,
                    ))
                .toList(),
          ));
  }
}
