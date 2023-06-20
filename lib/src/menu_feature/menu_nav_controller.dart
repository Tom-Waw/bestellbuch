import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu.dart';
import '../services/menu_service.dart';

class MenuNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static MenuNavController get to => Get.find<MenuNavController>();

  late final TabController controller;

  final Rxn<Menu> _current = Rxn<Menu>();
  Menu? get current => _current.value;

  @override
  void onInit() {
    super.onInit();
    final menus = MenuService.to.menus;
    if (menus.isNotEmpty) _current.value = menus.first;

    controller = TabController(length: menus.length, vsync: this);
    controller.addListener(() {
      if (controller.indexIsChanging) open(menus[controller.index]);
    });

    ever(menus, (ms) => refreshCurrent(ms));
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void refreshCurrent(List<Menu> menus) {
    Menu? menu = _current.value;
    List<String> ids = [];
    while (menu != null) {
      ids.add(menu.id);
      menu = menu.parent;
    }

    for (var id in ids.reversed) {
      menu = (menu?.items.whereType<Menu>().toList() ?? menus)
          .firstWhereOrNull((m) => m.id == id);
      if (menu == null) break;
    }

    _current.value = menu;
  }

  void open(Menu menu) => _current.value = menu;

  bool get canClose => _current.value?.isRoot == false;
  void close() => _current.value = current!.parent;
}
