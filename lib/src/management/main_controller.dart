import 'package:get/get.dart';

import 'api_service.dart';
import '../data/menu.dart';
import '../data/store.dart';
import '../data/table.dart';

/// A class to read and update the store including menu and tables.
class MainController extends GetxController {
  RxBool isLoading = false.obs;

  late final APIService _api;
  late Rx<Store> _store;
  late Rx<Menu> _ptrMenu;

  MainController(this._api);

  static MainController get to => Get.find<MainController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
  }

  /// Load the store data from the APIService.
  Future<void> loadData() async {
    isLoading(true);
    _store = (await _api.fetchData()).obs;
    _ptrMenu = rootMenus.first.obs;
    isLoading(false);
  }

  //? ####################### TABLE FEATURE #######################
  // Allow Widgets to read the currently selected menu.
  List<Table> get tables => _store.value.tables;

  /// Add and persist a new product based on the user's inputs.
  Future<void> addToTables(Table? t) async {
    if (t == null) return;

    // Store the new Item in memory
    _store.update((val) {
      val?.tables.add(t);
    });
    // Persist the changes to a database
    await _api.add(t);
  }

  /// Delete an existing table completely.
  Future<void> deleteFromTables(Table? t) async {
    if (t == null) return;

    // Remove Item from memory
    _store.update((val) {
      val?.tables.remove(t);
    });
    // Persist the changes to a database
    await _api.delete(t);
  }

  //? ####################### MENU FEATURE #######################
  // Allow Widgets to read the currently selected menu.
  Menu get menu {
    Menu m = _ptrMenu.value;
    m.items.sort((a, b) => a.name.compareTo(b.name));
    return m;
  }

  // Allow Widgets to read the root menus.
  List<Menu> get rootMenus => _store.value.menu.items.cast<Menu>();
  // Allow Widgets to read the currently selected root menu.
  Menu get selectedRootMenu {
    Menu m = menu;
    while (m.parent != _store.value.menu) {
      m = m.parent;
    }
    return m;
  }

  /// Select menu as current menu.
  void selectMenu(MenuItem menu) {
    if (menu is! Menu) return;
    _ptrMenu(menu);
  }

  /// Jump to parent of current menu.
  void back() {
    if (menu.parent == _store.value.menu) return;
    _ptrMenu(menu.parent);
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> addToMenu(MenuItem? item) async {
    if (item == null) return;

    // Store the new Item in memory
    item.setParent(menu);
    _ptrMenu.update((val) {
      val?.items.add(item);
    });
    // ! _store.update();

    // Persist the changes to a database
    await _api.add(item);
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteFromMenu(MenuItem? item) async {
    if (item == null || [item, item.parent].contains(_store.value.menu)) {
      return;
    }

    // Remove Item from memory
    _ptrMenu.update((val) {
      val?.items.remove(item);
    });
    // ! _store.update();

    // Persist the changes to a database
    await _api.delete(item);
  }
}
