import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/menu_service.dart';
import '../shared/utils.dart';
import 'menu_form.dart';
import 'menu_nav_controller.dart';

class MenuTabBar extends StatelessWidget implements PreferredSizeWidget {
  final bool editable;
  final void Function() exitEditMode;

  @override
  Size get preferredSize =>
      MenuService.to.menus.isNotEmpty ? const Size.fromHeight(55.0) : Size.zero;

  const MenuTabBar({
    super.key,
    this.editable = false,
    required this.exitEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MenuNavController.to.controller.value != null
          ? TabBar(
              controller: MenuNavController.to.controller.value,
              tabs: MenuService.to.menus
                  .map((menu) => Tab(text: menu.name))
                  .toList(),
              onTap: _onTap,
            )
          : const SizedBox.shrink(),
    );
  }

  void _onTap(int index) async {
    if (!editable) return;

    await Utils.showBottomSheet(
      "Hauptmenü anpassen",
      MenuForm(menu: MenuService.to.menus[index]),
    );
    return exitEditMode.call();
  }
}
