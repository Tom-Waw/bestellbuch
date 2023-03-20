import 'package:get/get.dart';

import 'catalog_service.dart';
import 'catalog.dart';

/// A class to read and update the product catalog.
class CatalogController extends GetxController {
  RxBool isLoading = false.obs;

  late final CatalogService _catalogService;
  late Rx<Catalog> _root;
  late Rx<Catalog> _current;

  CatalogController(this._catalogService);

  static CatalogController get to => Get.find<CatalogController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    loadCatalog();
  }

  // Allow Widgets to read the currently selected catalog.
  Catalog get current => _current.value;
  // Allow Widgets to check wether currently on root catalog or not.
  bool get isRoot => _current.value.parent == _root.value;
  // Allow Widgets to read the root catalogs.
  List<Catalog> get roots => _root.value.items.cast<Catalog>();
  // Allow Widgets to read the currently selected catalog.
  Catalog get selectedRoot {
    Catalog c = _current.value;
    while (c.parent != _root.value) {
      c = c.parent;
    }
    return c;
  }

  /// Load the catalog from the CatalogService.
  Future<void> loadCatalog() async {
    isLoading(true);
    Catalog catalog = await _catalogService.fetchData();
    _root = catalog.obs;
    _current = roots.first.obs;
    isLoading(false);
  }

  /// Select catalog as current catalog.
  void select(CatalogItem catalog) {
    if (catalog is! Catalog) return;
    _current(catalog);
  }

  /// Select catalog as current catalog.
  void back() {
    if (_current.value.parent == _root.value) return;
    _current(_current.value.parent);
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> add(CatalogItem? item) async {
    if (item == null) return;

    // Store the new Item in memory
    _current.update((val) {
      val?.items.add(item);
    });
    item.setParent(current);
    // Persist the changes to a database
    await _catalogService.add(item);
  }

  /// Delete an existing product or catalog completely.
  Future<void> delete(CatalogItem? item) async {
    if (item == null || [item, item.parent].contains(_root.value)) {
      return;
    }

    // Remove Item from memory
    _current.update((val) {
      val?.items.remove(item);
    });
    // Persist the changes to a database
    await _catalogService.delete(item);
  }
}
