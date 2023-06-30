import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';
import '../tables_feature/table.dart';
import 'order.dart';

class CheckoutController extends GetxController {
  static CheckoutController get to => Get.find<CheckoutController>();

  final Rxn<Order> _order = Rxn<Order>();

  bool get isReady => _order.value != null;
  Order get order => _order.value!;

  final List<Worker> _workers = [];
  bool _preventUpdate = false;

  @override
  void onInit() async {
    super.onInit();

    Table table = Get.arguments;
    Order current = await OrderService.to.getOrCreateOrder(table);
    if (current.waiter != AuthService.to.currentUser) {
      Get.snackbar(
        "Warning",
        "Der Tisch wird bereits von ${current.waiter.name} bedient. Sie werden als Kellner eingetragen.",
        snackPosition: SnackPosition.BOTTOM,
      );
      current.waiter = AuthService.to.currentUser;
    }

    _workers.addAll([
      ever(
        _order,
        (order) => order != null
            ? OrderService.to.updateOrder(order)
            : Get.offAllNamed(Routes.tables),
        condition: () => !_preventUpdate,
      ),
      ever(
        OrderService.to.orders,
        (orders) {
          Order? order = orders.firstWhereOrNull(
            (o) => o.id == _order.value?.id,
          );
          if (order == null) return Get.back(closeOverlays: true);
          _preventUpdate = true;
          _order.value = order;
          _preventUpdate = false;
        },
      ),
    ]);

    _order.value = current;
  }

  @override
  void onClose() {
    for (Worker worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }

  void addItem(Product product) {
    _order.update((val) => val?.addItem(product));
  }

  void removeItem(Product product) {
    _order.update((val) => val?.removeItem(product));
  }

  void removeProduct(Product product) {
    _order.update((val) => val?.removeProduct(product));
  }

  void removeItems(Map<Product, int> items) {
    _order.update((val) => val?.removeItems(items));
  }

  Future<void> transferItemsToTable(
    Table table,
    Map<Product, int> items,
  ) async {
    if (_order.value == null || table == _order.value!.table || items.isEmpty) {
      return;
    }

    Order prev = _order.value!;

    _order.update((val) => val?.removeItems(items));
    Order target = await OrderService.to.getOrCreateOrder(table);
    target.addItems(items);

    _order.value = target;

    if (prev.items.isEmpty == true) await OrderService.to.cancelOrder(prev);
  }

  Future<void> checkout(Map<Product, int> items) async {
    if (_order.value == null || items.isEmpty) return;

    _order.update((val) => val?.payItems(items));
    if (_order.value!.items.isEmpty == true) {
      await OrderService.to.cancelOrder(_order.value!);
      Get.offAllNamed(Routes.tables);
    }
  }
}
