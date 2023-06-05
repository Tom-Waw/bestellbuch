import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:get/get.dart';

import '../auth/auth_service.dart';
import '../menu_feature/menu.dart';
import 'order.dart';
import '../tables_feature/table.dart';

/// A class to read and update an order.
class OrderController extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Orders");

  static OrderController get to => Get.find<OrderController>();

  late final Rx<Order?> _order;

  @override
  void onInit() async {
    super.onInit();

    Table table = Get.arguments;
    var existingRef = await _ref
        .where("table", isEqualTo: table.number)
        .where("active", isEqualTo: true)
        .get();

    if (existingRef.docs.isEmpty) {
      String id = _ref.doc().id;
      _order = Order(
        id: id,
        table: table,
        waiter: AuthService.to.employee,
      ).obs;

      return await _ref.doc(id).set(_order.value!.toJson());
    }

    final doc = existingRef.docs.first;
    final order = Order.fromJson(doc.id, doc.data());
    if (order.waiter != AuthService.to.employee) {
      Get.snackbar(
        "Error",
        "Table already opened by ${order.waiter}",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _order = order.obs;
  }

  // Allow Widgets to access the current order.
  bool get isReady => _order.value != null;
  Order get order => _order.value!;

  void addItem(Product product) {
    _order.update((val) {
      val?.items.update(product, (count) => count + 1, ifAbsent: () => 1);
    });
    saveOrder();
  }

  void removeItem(Product product) {
    _order.update((val) {
      if (val?.items[product] == 1) return removeProduct(product);
      val?.items.update(product, (count) => count - 1);
    });
    saveOrder();
  }

  void removeProduct(Product product) {
    _order.update((val) {
      val?.items.remove(product);
    });
    saveOrder();
  }

  Future<void> saveOrder() async =>
      await _ref.doc(order.id).set(order.toJson());

  Future<void> closeOrder() async {
    _order.update((val) {
      val?.active = false;
    });
    await saveOrder();
  }

  Future<void> removeOrder() async => await _ref.doc(order.id).delete();
}
