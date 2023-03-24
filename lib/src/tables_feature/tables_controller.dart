import 'package:get/get.dart';

import 'tables_service.dart';
import 'table.dart';

/// A class to read and update the product catalog.
class TablesController extends GetxController {
  RxBool isLoading = false.obs;

  late final TablesService _tablesService;
  late RxList<Table> _tables;

  TablesController(this._tablesService);

  static TablesController get to => Get.find<TablesController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    loadTables();
  }

  // Allow Widgets to read the currently selected catalog.
  List<Table> get tables => _tables.toList();

  /// Load the catalog from the CatalogService.
  Future<void> loadTables() async {
    isLoading(true);
    _tables = (await _tablesService.fetchData()).obs;
    isLoading(false);
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> add(Table? t) async {
    if (t == null) return;

    // Store the new Item in memory
    _tables.add(t);
    // Persist the changes to a database
    await _tablesService.add(t);
  }

  /// Delete an existing product or catalog completely.
  Future<void> delete(Table? t) async {
    if (t == null) return;

    // Remove Item from memory
    _tables.remove(t);
    // Persist the changes to a database
    await _tablesService.delete(t);
  }
}
