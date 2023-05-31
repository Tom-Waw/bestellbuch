import 'package:get/get.dart';

import 'api_service.dart';
import 'state_service.dart';
import '../data/menu.dart';

/// A class to read and update menu.
class MenuController extends GetxController {
  final List<Menu> menus = StateService.to.menus;
  late final Rx<Menu> _current;
  Rx<bool> isEditing = false.obs;

  MenuController();

  static MenuController get to => Get.find<MenuController>();

  @override
  void onInit() {
    _current = menus.first.obs;
    super.onInit();
  }

  @override
  void onClose() {
    StateService.to.syncState();
    super.onClose();
  }

  void toggleEdit() => isEditing.toggle();

  // Allow Widgets to read the current menu.
  Menu get menu => _current.value;

  void openMenu(Menu menu) => _current(menu);

  void closeMenu() => _current(menu.parent);

  /// Add and persist a new product based on the user's inputs.
  Future<void> addItem(Map<String, dynamic> data) async {
    if (data.isEmpty) return;

    // Create data in database
    var response = await APIService.to.addToMenu(data, menu.path);
    MenuItem item = MenuItem.fromJson(response);

    // Update observable
    _current.update((val) async {
      item.parent = val;
      val?.items.add(item);
    });
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteFromMenu(MenuItem? item) async {
    if (item == null || menus.contains(item)) return;

    // Delete data from database
    await APIService.to.deleteFromMenu(item.path);

    // Update observable
    _current.update((val) async {
      val?.items.remove(item);
    });
  }
}
