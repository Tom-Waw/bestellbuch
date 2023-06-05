import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'menu.dart';

/// A class to read and update menu.
class MenuController extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Menu");

  static MenuController get to => Get.find<MenuController>();

  final RxList<Menu> menus = <Menu>[].obs;

  @override
  void onInit() {
    super.onInit();
    menus.bindStream(_dbStream());
  }

  Stream<List<Menu>> _dbStream() => _ref.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Menu.fromJson(doc.data())).toList());

  Menu get menu => Get.arguments ?? menus.first;

  /// Add and persist a new product based on the user's inputs.
  Future<void> addItem(Map<String, dynamic> data) async {
    if (data.isEmpty) return;

    await _ref.doc(menu.path).collection("items").add(data);
  }

  /// Delete an existing product or menu completely.
  Future<void> deleteFromMenu(MenuItem? item) async {
    if (item == null || menus.contains(item)) return;

    await _ref.doc(item.path).delete();
  }
}
