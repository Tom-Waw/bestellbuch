import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import 'order_service.dart';

// A class to read and update menu.
class MenuService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Menu");
  final _streamSubscriptions =
      <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];

  static MenuService get to => Get.find<MenuService>();

  final RxList<Menu> menus = <Menu>[].obs;

  List<Menu> get allMenus => menus.expand((m) => m.allMenus).toList();
  List<Product> get allProducts => menus.expand((m) => m.allProducts).toList();

  Future<MenuService> init() async {
    await _reloadMenus();
    _ref.snapshots().listen((_) => _reloadMenus());
    return this;
  }

  @override
  void onClose() {
    super.onClose();
    for (var sub in _streamSubscriptions) {
      sub.cancel();
    }
    _streamSubscriptions.clear();
    menus.close();
  }

  Future<void> _reloadMenus() async {
    for (var sub in _streamSubscriptions) {
      sub.cancel();
    }
    _streamSubscriptions.clear();
    final fetchedMenus = await _fetchMenus(await _ref.get());
    menus.value = fetchedMenus.cast<Menu>();
  }

  Future<List<MenuItem>> _fetchMenus(
          QuerySnapshot<Map<String, dynamic>> ref) async =>
      Future.wait(ref.docs.map((doc) async {
        final data = doc.data();

        final innerRef = doc.reference.collection("items");
        final snapshot = await innerRef.get();
        if (snapshot.size > 0) {
          data["items"] = await _fetchMenus(snapshot);
          final sub = innerRef.snapshots().listen((_) => _reloadMenus());
          _streamSubscriptions.add(sub);
        }

        return MenuItem.fromJson(doc.id, data);
      }).toList());

  String? _checkName(String name, {MenuItem? item}) {
    if (name.isEmpty) return "Bitte geben Sie einen Namen an";
    if ((allProducts.cast<MenuItem>() + allMenus.cast<MenuItem>())
        .any((i) => i.name == name && i.id != item?.id)) {
      return "Dieser Name existiert bereits";
    }
    return null;
  }

  // Add and persist a new product based on the user's inputs.
  Future<String?> addProduct({
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

  // Add and persist a new menu based on the user's inputs.
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

  // Update an existing product or menu based on the user's inputs.
  Future<String?> updateItem(MenuItem item) async {
    String? error = _checkName(item.name, item: item);
    if (error != null) return error;

    await _ref.doc(item.path).set(item.toJson());
    return null;
  }

  // Delete an existing product or menu.
  Future<String?> deleteItem(MenuItem? item) async {
    if (item == null || menus.contains(item)) return null;

    if (item is Product &&
        OrderService.to.activeOrders.any(
          (o) => o.items.keys.contains(item),
        )) {
      return "Dieses Produkt wird noch in einer aktiven Bestellung verwendet";
    }

    if (item is Menu &&
        OrderService.to.activeOrders.any(
          (o) => item.allProducts.any((p) => o.items.keys.contains(p)),
        )) {
      return "Produkte aus diesem Menü werden noch in einer aktiven Bestellung verwendet";
    }

    await _ref.doc(item.path).delete();
    return null;
  }
}
