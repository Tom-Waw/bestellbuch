import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu.dart';
import 'menu_service.dart';

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
    controller = TabController(length: _menus.length, vsync: this);
    if (_menus.isNotEmpty) open(_menus.first);
    controller.addListener(() {
      if (controller.indexIsChanging) open(_menus[controller.index]);
    });
    _menus.listen((_) { });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void open(Menu menu) => _current.value = menu;

  void close() => _current.value = current?.parent ?? current;
}
