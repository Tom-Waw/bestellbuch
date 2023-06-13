import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'menu.dart';
import 'menu_nav_controller.dart';

/// A class to read and update menu.
class MenuService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Menu");
  final _streamSubscriptions =
      <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];

  static MenuService get to => Get.find<MenuService>();

  final RxList<Menu> menus = <Menu>[].obs;

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

  /// Add and persist a new product based on the user's inputs.
  Future<void> addItem(Map<String, dynamic> data) async {
    if (data.isEmpty) return;

    await _ref
        .doc(MenuNavController.to.current!.path)
        .collection("items")
        .add(data);
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteFromMenu(MenuItem? item) async {
    if (item == null || menus.contains(item)) return;

    await _ref.doc(item.path).delete();
  }
}
