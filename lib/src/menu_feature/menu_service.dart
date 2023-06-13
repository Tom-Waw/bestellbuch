import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'menu.dart';

/// A class to read and update menu.
class MenuService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Menu");
  final _streamSubscriptions =
      <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];

  static MenuService get to => Get.find<MenuService>();

  final RxList<Menu> menus = <Menu>[].obs;
  List<Product> get allProducts =>
      menus.expand((menu) => menu.allProducts).toList();

  @override
  void onInit() {
    super.onInit();

    _updateMenus();
    _ref.snapshots().listen((_) => _updateMenus());
  }

  void _updateMenus() async {
    for (var sub in _streamSubscriptions) {
      sub.cancel();
    }
    _streamSubscriptions.clear();
    final fetchedMenus = await _fetchMenus(await _ref.get());
    menus.clear();
    menus.addAll(fetchedMenus.cast<Menu>());
  }

  Future<List<MenuItem>> _fetchMenus(
          QuerySnapshot<Map<String, dynamic>> ref) async =>
      Future.wait(ref.docs.map((doc) async {
        final data = doc.data();

        final innerRef = doc.reference.collection("items");
        final snapshot = await innerRef.get();
        if (snapshot.size > 0) {
          data["items"] = await _fetchMenus(snapshot);
          final sub = innerRef.snapshots().listen((_) => _updateMenus());
          _streamSubscriptions.add(sub);
        }

        return MenuItem.fromJson(doc.id, data);
      }).toList());

  String? _checkName(String name, {MenuItem? item}) {
    if (name.isEmpty) return "Bitte geben Sie einen Namen an";
    if (allProducts
        .any((product) => product.name == name && product.id != item?.id)) {
      return "Dieser Name existiert bereits";
    }
    return null;
  }

  /// Add and persist a new product based on the user's inputs.
  Future<String?> addProductTo({
    required Menu menu,
    required String name,
    required double price,
  }) async {
    String? error = _checkName(name);
    if (error != null) return error;

    Product product = Product(
      id: _ref.doc().id,
      name: name,
      price: price,
    );
    await _ref
        .doc(menu.path)
        .collection("items")
        .doc(product.id)
        .set(product.toJson());
    return null;
  }

  /// Add and persist a new menu based on the user's inputs.
  Future<String?> addMenu({Menu? parent, required String name}) async {
    String? error = _checkName(name);
    if (error != null) return error;

    Menu menu = Menu(
      id: _ref.doc().id,
      name: name,
    );
    if (parent != null) {
      await _ref
          .doc(parent.path)
          .collection("items")
          .doc(menu.id)
          .set(menu.toJson());
    } else {
      await _ref.doc(menu.id).set(menu.toJson());
    }
    return null;
  }

  /// Update an existing product or menu based on the user's inputs.
  Future<String?> updateItem(MenuItem item) async {
    String? error = _checkName(item.name, item: item);
    if (error != null) return error;

    await _ref.doc(item.path).update(item.toJson());
    return null;
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteItem(MenuItem? item) async {
    if (item == null || menus.contains(item)) return;

    await _ref.doc(item.path).delete();
  }
}
