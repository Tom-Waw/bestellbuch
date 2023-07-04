import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:get/get.dart';

import '../order_feature/order.dart';
import '../tables_feature/table.dart';
import 'auth_service.dart';
import 'employee_service.dart';
import 'menu_service.dart';
import 'table_service.dart';

/// A class to read and update an order.
class OrderService extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Orders");
  final _archiveRef = FirebaseFirestore.instance.collection("History");

  static OrderService get to => Get.find<OrderService>();

  final RxList<Order> orders = <Order>[].obs;

  final List<Worker> _workers = [];

  @override
  void onInit() async {
    super.onInit();
    orders.bindStream(_dbStream());

    void fetchOrders(_) async => orders.value = await _dbStream().last;

    _workers.addAll([
      ever(EmployeeService.to.groups, fetchOrders),
      ever(TableService.to.groups, fetchOrders),
      ever(MenuService.to.menus, fetchOrders),
    ]);
  }

  @override
  void onClose() {
    for (var worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }

  Stream<List<Order>> _dbStream() => _ref.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Order.fromJson(doc.id, doc.data())).toList());

  Future<Order> getOrCreateOrder(Table table) async {
    Order? order = orders.firstWhereOrNull((order) => order.table == table);

    if (order != null) return order;

    String id = _ref.doc().id;
    order = Order(
      id: id,
      table: table,
      waiter: AuthService.to.currentUser,
    );
    await _ref.add(order.toJson());
    return orders.firstWhere((order) => order.table == table);
  }

  Future<void> updateOrder(Order order) async =>
      await _ref.doc(order.id).set(order.toJson());

  Future<void> cancelOrder(Order order) async =>
      await _ref.doc(order.id).delete();

  Future<void> archiveOrder(Order current) async {
    await _archiveRef.doc(current.id).set(current.toArchiveJson());

    await _ref.doc(current.id).delete();
  }
}
