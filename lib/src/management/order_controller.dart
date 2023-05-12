import 'package:get/get.dart';

import '../data/menu.dart';
import '../data/order.dart';
import '../data/table.dart';
import 'api_service.dart';

/// A class to read and update an order.
class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  late final Rx<Order> _order;

  OrderController();

  static OrderController get to => Get.find<OrderController>();

  @override
  void onInit() async {
    isLoading(true);

    // TODO: check if table is already opened by current user
    Table table = Get.arguments;

    var response = await APIService.to.getOrCreateOrder(table.id);
    _order = Order.fromJson(response).obs;

    isLoading(false);
    super.onInit();
  }

  // Allow Widgets to access the current order.
  Order get order => _order.value;

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
      await APIService.to.saveOrder(_order.value.toJson());

  Future<void> closeOrder() async {
    _order.update((val) {
      val?.active = false;
    });
    await saveOrder();
  }

  Future<void> removeOrder() async {
    await APIService.to.deleteOrder(_order.value.id);
  }
}
