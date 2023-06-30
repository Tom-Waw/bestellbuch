import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/menu_service.dart';
import 'menu.dart';

class MenuNavController extends GetxController
    with GetTickerProviderStateMixin {
  static MenuNavController get to => Get.find<MenuNavController>();

  final Rxn<TabController> controller = Rxn<TabController>();

  final Rxn<Menu> _current = Rxn<Menu>();
  Menu? get current => _current.value;

  @override
  void onReady() {
    super.onReady();
    MenuService.to.menus.listenAndPump((ms) => _reloadData(ms));
  }

  @override
  void dispose() {
    controller.value?.dispose();
    super.dispose();
  }

  void _reloadData(List<Menu> menus) {
    controller.value?.dispose();

    reloadCurrent(menus);
    if (menus.isEmpty) return;

    final tc = TabController(
      initialIndex:
          _current.value != null ? menus.indexOf(_current.value!.root) : 0,
      length: menus.length,
      vsync: this,
    );
    tc.addListener(() => tc.indexIsChanging ? open(menus[tc.index]) : null);
    controller.value = tc;

    _current.value = _current.value ?? menus[controller.value!.index];
  }

  void reloadCurrent(List<Menu> menus) {
    Menu? menu = _current.value;
    List<String> path = [];
    while (menu != null) {
      path.add(menu.id);
      menu = menu.parent;
    }

    for (var id in path.reversed) {
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
