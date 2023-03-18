import 'package:get/get.dart';

import 'catalog_service.dart';
import 'catalog.dart';

/// A class to read and update the product catalog.
class CatalogController extends GetxController {
  late final CatalogService _catalogService;
  late Catalog _root;
  late Catalog _current;

  CatalogController(this._catalogService);

  @override
  void onInit() async {
    super.onInit();
    await loadCatalog();
  }

  // Allow Widgets to read the currently selected catalog.
  Rx<Catalog> get root {
    Catalog c = _current;
    while (c.parent != _root) {
      c = c.parent;
    }
    return c.obs;
  }

  // Allow Widgets to read the currently selected catalog.
  Rx<Catalog> get current => _current.obs;
  // Allow Widgets to check wether currently on root catalog or not.
  Rx<bool> get isRoot => (_current.parent == _root).obs;

  /// Load the catalog from the CatalogService.
  Future<void> loadCatalog() async {
    _root = await _catalogService.catalog();
    _current = _root.items.first as Catalog;
  }

  /// Select catalog as current catalog.
  void select(CatalogItem catalog) {
    if (catalog is! Catalog) return;
    _current = catalog;
  }

  /// Select catalog as current catalog.
  void back() {
    if (_current.parent == _root) return;
    _current = _current.parent;
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> add(CatalogItem? item) async {
    if (item == null) return;

    // Store the new Item in memory
    _current.items.add(item);
    item.setParent(_current);
    // Persist the changes to a database
    await _catalogService.add(item);
  }

  /// Delete an existing product or catalog completely.
  Future<void> delete(CatalogItem? item) async {
    if (item == null || item == _root || item.parent == _root) return;

    // Remove Item from memory
    _current.items.remove(item);
    // Persist the changes to a database
    await _catalogService.delete(item);
  }
}
