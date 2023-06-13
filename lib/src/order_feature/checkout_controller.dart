import 'package:get/get.dart';

import '../auth/auth_service.dart';
import '../menu_feature/menu.dart';
import '../tables_feature/table.dart';
import 'order.dart';
import 'order_service.dart';

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
  }

  void addItem(Product product) {
    _order.update((val) {
      val?.items.update(product, (count) => count + 1, ifAbsent: () => 1);
    });
    OrderService.to.updateOrder(current);
  }

  void removeItem(Product product) {
    _order.update((val) {
      if (val?.items[product] == 1) return removeProduct(product);
      val?.items.update(product, (count) => count - 1);
    });
    OrderService.to.updateOrder(current);
  }

  void removeProduct(Product product) {
    _order.update((val) {
      val?.items.remove(product);
    });
    OrderService.to.updateOrder(current);
  }

  Future<void> checkout() async {
    _order.update((val) {
      val?.active = false;
    });
    OrderService.to.updateOrder(current);
  }
}
