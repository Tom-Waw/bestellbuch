import 'dart:math';

import 'package:get/get.dart';

import 'api_service.dart';
import '../data/menu.dart';
import '../data/order.dart';
import '../data/store.dart';
import '../data/table.dart';

/// A class to read and update the store including menu and tables.
class MainController extends GetxController {
  RxBool isLoading = false.obs;

  late final APIService _api;
  late final Rx<Store> _store;
  late final Rx<Table?> _tablePtr = null.obs;
  late Rx<Menu> _menuPtr;

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
  void addToMenu(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    // Update observable
    _store.update((_) async {
      isLoading(true);

      // Create data in database
      var response = await _api.addToMenu(data, menu.path);
      MenuItem item = MenuItem.fromJson(response);

      // Save data in memory
      _menuPtr.update((val) {
        item.parent = val;
        val?.items.add(item);
      });

      isLoading(false);
    });
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteFromMenu(MenuItem? item) async {
    if (item == null || rootMenus.contains(item)) return;

    // Update observable
    _store.update((_) async {
      isLoading(true);

      // Delete data from database
      await _api.deleteFromMenu(item.path);

      // Remove data from memory
      _menuPtr.update((val) {
        val?.items.remove(item);
      });

      isLoading(false);
    });
  }

//? ####################### ORDER FEATURE #######################
// Allow Widgets to read the orders.
  Map<Table, Order> get orders => _store.value.orders;

  Order? get order => _store.value.orders[_tablePtr.value != null];

  void openTable(Table table) {
    _tablePtr(table);
  }

  void closeTable() {
    _tablePtr(null);
  }

  /// Load the order data from the APIService.
  Future<void> loadOrder() async {
    isLoading(true);
    // Store data = await _api.fetchData();
    // _store = data.obs;
    // _menuPtr = (data.menu.items.first as Menu).obs;
    isLoading(false);
  }
}
