import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import 'auth_service.dart';
import '../tables_feature/table.dart';
import '../order_feature/order.dart';
import 'employee_service.dart';
import 'menu_service.dart';
import 'table_service.dart';

/// A class to read and update an order.
class OrderService extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Orders");

  static OrderService get to => Get.find<OrderService>();

  final RxList<Order> activeOrders = <Order>[].obs;

  @override
  void onInit() async {
    super.onInit();
    activeOrders.bindStream(_dbStream());

    ever(TableService.to.tableGroups, (_) {
      for (var order in activeOrders) {
        order.table = TableService.to.allTables.firstWhere(
          (t) =>
              t.group.id == order.table.group.id &&
              t.number == order.table.number,
        );
      }
    });
    ever(EmployeeService.to.employees, (_) {
      for (var order in activeOrders) {
        order.waiter = EmployeeService.to.employees
            .firstWhere((employee) => employee.id == order.waiter.id);
      }
    });
    ever(MenuService.to.menus, (_) async {
      for (var order in activeOrders) {
        order.items.map((key, value) {
          Product product =
              MenuService.to.allProducts.firstWhere((p) => p.id == key.id);

          return MapEntry(product, value);
        });
      }
    });
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
      table: table,
      waiter: AuthService.to.employee,
    );
    await _ref.add(order.toJson());
    return activeOrders.firstWhere((order) => order.table == table);
  }

  Future<void> updateOrder(Order order) async =>
      await _ref.doc(order.id).set(order.toJson());

  Future<void> cancelOrder(Order order) async =>
      await _ref.doc(order.id).delete();
}
