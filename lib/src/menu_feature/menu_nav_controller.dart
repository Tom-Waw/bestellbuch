import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu.dart';
import 'menu_service.dart';

class MenuNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static MenuNavController get to => Get.find<MenuNavController>();

  final _menus = MenuService.to.menus;
  late final TabController controller;

  final RxList<String> _idStack = <String>[].obs;
  Menu? get current {
    Menu? menu;
    for (final id in _idStack) {
      menu = (menu?.items ?? _menus)
          .whereType<Menu>()
          .toList()
          .firstWhereOrNull((m) => m.id == id);
      if (menu == null) break;
    }
    if (menu == null) _idStack.clear();
    return menu;
  }

  @override
  void onInit() {
    super.onInit();
    controller = TabController(length: _menus.length, vsync: this);
    if (_menus.isNotEmpty) open(_menus.first);
    controller.addListener(() {
      if (controller.indexIsChanging) open(_menus[controller.index]);
    });
    _menus.listen((_) => _idStack.refresh());
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  List<String> menuToIdStack(Menu menu) =>
      [if (!menu.isRoot) ...menuToIdStack(menu.parent!), menu.id];

  void open(Menu menu) => _idStack.value = menuToIdStack(menu);

  void close() => _idStack.removeLast();
}
