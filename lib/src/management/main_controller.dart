import 'dart:math';

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
  late Rx<Menu> _menuPtr;

  MainController(this._api);

  static MainController get to => Get.find<MainController>();

  @override
  Future<void> onInit() async {
    loadData();
    super.onInit();
  }

  /// Load the store data from the APIService.
  Future<void> loadData() async {
    isLoading(true);
    var response = await _api.fetchData();

    Store store = Store(
      menus: response["menus"].map(Menu.fromJson).cast<Menu>().toList(),
      tables: response["tables"].map(Table.fromJson).cast<Table>().toList(),
    );

    _store = store.obs;
    _menuPtr = store.menus.first.obs;
    isLoading(false);
  }

  //? ####################### TABLE FEATURE #######################
  // Allow Widgets to read the currently selected menu.
  List<Table> get tables => _store.value.tables;

  /// Add and persist a new product based on the user's inputs.
  void addNTables(int n) {
    if (n <= 0) return;

    // Update observable
    _store.update((val) async {
      isLoading(true);
      for (int i = 0; i < n; i++) {
        // Create data in database
        var response = await _api.addTable();
        Table table = Table.fromJson(response);

        // Save data in memory
        val?.tables.add(table);
      }
      isLoading(false);
    });
  }

  /// Add and persist a new product based on the user's inputs.
  void deleteNTables(int n) {
    if (n <= 0) return;

    var rTables = List.from(tables.where((t) => t.number > tables.length - n));

    // Update observable
    _store.update((val) async {
      isLoading(true);
      for (var table in rTables) {
        // Delete data from database
        await _api.deleteTable(table.id);

        // Remove data from memory
        val?.tables.remove(table);
      }
      isLoading(false);
    });
  }

  //? ####################### MENU FEATURE #######################
  // Allow Widgets to read the root menus.
  List<Menu> get rootMenus => _store.value.menus;

  // Allow Widgets to read the current menu.
  Menu get menu => _menuPtr.value;

  void openMenu(Menu menu) {
    _menuPtr(menu);
  }

  void closeMenu() {
    _menuPtr(_menuPtr.value.parent);
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> addToMenu(MenuItem? item) async {
    if (item == null) return;

    // Store the new Item in memory
    _menuPtr.update((val) {
      item.parent = menu;
      val?.items.add(item);
    });

    // Persist the changes to a database
    //await _api.addToMenu(item);
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteFromMenu(MenuItem? item) async {
    if (item == null || rootMenus.contains(item)) {
      return;
    }

    // Remove Item from memory
    _menuPtr.update((val) {
      val?.items.remove(item);
    });

    // Persist the changes to a database
    //await _api.delete(item);
  }
}
