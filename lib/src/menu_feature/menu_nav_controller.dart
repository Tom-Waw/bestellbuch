import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu.dart';
import '../services/menu_service.dart';

class MenuNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static MenuNavController get to => Get.find<MenuNavController>();

  final _menus = MenuService.to.menus;
  late final TabController controller;

  final Rxn<Menu> _current = Rxn<Menu>();
  Menu? get current => _current.value;

  @override
  void onInit() {
    super.onInit();
    if (_menus.isNotEmpty) _current.value = _menus.first;

    controller = TabController(length: _menus.length, vsync: this);
    controller.addListener(() {
      if (controller.indexIsChanging) open(_menus[controller.index]);
    });

    ever(_menus, (_) => refreshCurrent());
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void refreshCurrent() {
    Menu? menu = _current.value;
    List<String> ids = [];
    while (menu != null) {
      ids.add(menu.id);
      menu = menu.parent;
    }

    for (var id in ids.reversed) {
      menu = (menu?.items.whereType<Menu>().toList() ?? _menus)
          .firstWhereOrNull((m) => m.id == id);
      if (menu == null) break;
    }

    _current.value = menu;
  }

  void open(Menu menu) => _current.value = menu;

  bool get canClose => _current.value?.isRoot == false;
  void close() => _current.value = current!.parent;
}
