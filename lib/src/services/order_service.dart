import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:get/get.dart';

import 'auth_service.dart';
import '../tables_feature/table.dart';
import '../order_feature/order.dart';

/// A class to read and update an order.
class OrderService extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Orders");

  static OrderService get to => Get.find<OrderService>();

  final RxList<Order> activeOrders = <Order>[].obs;

  @override
  void onInit() async {
    super.onInit();
    activeOrders.bindStream(_dbStream());
  }

  @override
  void onClose() {
    super.onClose();
    activeOrders.close();
  }

  Stream<List<Order>> _dbStream() => _ref
      .where("active", isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Order.fromJson(doc.id, doc.data()))
          .toList());

  Future<Order> getOrCreateOrder(Table table) async {
    Order? order =
        activeOrders.firstWhereOrNull((order) => order.table == table);

    if (order != null) {
      return order;
    }

    String id = _ref.doc().id;
    order = Order(
      id: id,
      tableId: "${table.group.id}@${table.number}",
      waiterId: AuthService.to.currentUser.id,
    );
    await _ref.add(order.toJson());
    return activeOrders.firstWhere((order) => order.table == table);
  }

  Future<void> updateOrder(Order order) async =>
      await _ref.doc(order.id).set(order.toJson());

  Future<void> cancelOrder(Order order) async =>
      await _ref.doc(order.id).delete();
}
