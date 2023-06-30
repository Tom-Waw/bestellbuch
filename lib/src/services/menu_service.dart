import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import 'order_service.dart';

// A class to read and update menu.
class MenuService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Menus");

  static MenuService get to => Get.find<MenuService>();

  final RxList<Menu> menus = <Menu>[].obs;

  List<Menu> get allMenus => menus.expand((m) => m.allMenus).toList();
  List<Product> get allProducts => menus.expand((m) => m.allProducts).toList();

  @override
  void onInit() async {
    super.onInit();
    menus.bindStream(_dbStream());
  }

  Stream<List<Menu>> _dbStream() => _ref.snapshots().map(
        (snapshot) => structureData(snapshot.docs).whereType<Menu>().toList(),
      );

  List<MenuItem> structureData(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> remaining, [
    Menu? parent,
  ]) {
    final docs =
        List.from(remaining.where((d) => d.data()["parent"] == parent?.id));
    docs.forEach(remaining.remove);

    List<MenuItem> items =
        docs.map((d) => MenuItem.fromJson(d.id, parent, d.data())).toList();
    items.sort();

    return items
      ..whereType<Menu>().forEach(
        (menu) => menu.items.addAll(structureData(List.from(remaining), menu)),
      );
  }

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
      parent: menu,
      name: name,
      price: price,
    );
    await _ref.doc(product.id).set(product.toJson());
    return null;
  }

  // Add and persist a new menu based on the user's inputs.
  Future<String?> addMenu({Menu? parent, required String name}) async {
    String? error = _checkName(name);
    if (error != null) return error;

    Menu menu = Menu(
      id: _ref.doc().id,
      parent: parent,
      name: name,
    );
    await _ref.doc(menu.id).set(menu.toJson());
    return null;
  }

  // Update an existing product or menu based on the user's inputs.
  Future<String?> updateItem(MenuItem item) async {
    String? error = _checkName(item.name, item: item);
    if (error != null) return error;

    await _ref.doc(item.id).set(item.toJson());
    return null;
  }

  // Delete an existing product or menu.
  Future<String?> deleteItem(MenuItem? item) async {
    if (item == null || menus.contains(item)) return null;

    if (item is Product &&
        OrderService.to.orders.any(
          (o) => o.items.keys.contains(item),
        )) {
      return "Dieses Produkt wird noch in einer aktiven Bestellung verwendet";
    }

    if (item is Menu &&
        OrderService.to.orders.any(
          (o) => item.allProducts.any((p) => o.items.keys.contains(p)),
        )) {
      return "Produkte aus diesem Menü werden noch in einer aktiven Bestellung verwendet";
    }

    await _ref.doc(item.id).delete();
    return null;
  }
}
