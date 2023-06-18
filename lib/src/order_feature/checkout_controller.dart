import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../menu_feature/menu.dart';
import '../tables_feature/table.dart';
import 'order.dart';
import '../services/order_service.dart';

class CheckoutController extends GetxController {
  static CheckoutController get to => Get.find<CheckoutController>();

  final Rxn<Order> _order = Rxn<Order>();

  // Allow Widgets to access the current order.
  bool get isReady => _order.value != null;
  Order get current => _order.value!;

  @override
  void onInit() async {
    super.onInit();

    Table table = Get.arguments;
    Order order = await OrderService.to.getOrCreateOrder(table);

    if (order.waiter != AuthService.to.employee) {
      Get.snackbar(
        "Error",
        "Table already opened by ${order.waiter.name}",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _order.value = order;

    ever(OrderService.to.activeOrders, (orders) async {
      if (_order.value == null) return;

      Order? order = orders.firstWhereOrNull(
        (o) => o.id == _order.value?.id,
      );

      if (order == null) {
        await OrderService.to.cancelOrder(_order.value!);
        Get.back();
      } else {
        _order.value = order;
      }
    });
  }

  Future<void> addItem(Product product) async {
    _order.update((val) async {
      // val?.items.update(product, (count) => count + 1, ifAbsent: () => 1);
      Product? key =
          val?.items.keys.toList().firstWhereOrNull((p) => p.id == product.id);
      if (key == null) {
        val?.items[product] = 1;
      } else {
        val?.items.update(key, (value) => value + 1);
      }
      await OrderService.to.updateOrder(current);
    });
  }

  Future<void> removeItem(Product product) async {
    _order.update((val) async {
      if (val?.items[product] == 1) return await removeProduct(product);
      val?.items.update(product, (count) => count - 1);

      await OrderService.to.updateOrder(current);
    });
  }

  Future<void> removeProduct(Product product) async {
    _order.update((val) async {
      val?.items.remove(product);

      await OrderService.to.updateOrder(current);
    });
  }

  Future<void> checkout() async {
    _order.update((val) async {
      val?.active = false;
      await OrderService.to.updateOrder(current);
    });
  }
}
