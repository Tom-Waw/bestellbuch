import 'package:flutter/material.dart' hide Table;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import '../routes.dart';
import '../services/order_service.dart';
import '../shared/utils.dart';
import '../tables_feature/table.dart';
import 'checkout_controller.dart';
import 'checkout_page.dart';
import 'order.dart';
import 'order_selection_view.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => !CheckoutController.to.isReady
        ? Scaffold(
            appBar: AppBar(title: const Text("Bestellung")),
            body: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(CheckoutController.to.order.table.name),
              actions: [
                IconButton(
                  onPressed: () => Utils.showBottomSheet(
                    "Bestellung umbuchen",
                    OrderSelectionView(
                      order: CheckoutController.to.order,
                      onSubmit: (selection) async {
                        dynamic table = await Get.toNamed(Routes.tables);
                        if (table is! Table) return;

                        await CheckoutController.to.transferItemsToTable(
                          table,
                          selection,
                        );
                      },
                    ),
                  ),
                  icon: const Icon(Icons.ios_share),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    Product product = await Get.toNamed(Routes.menu);
                    CheckoutController.to.addItem(product);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => Utils.showConfirmDialog(
                    "Willst du diese Bestellung mit allen Inhalten wirklich löschen?",
                    () async => await OrderService.to
                        .cancelOrder(CheckoutController.to.order),
                  ),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: CheckoutController.to.order.items.length,
              itemBuilder: (_, index) {
                MapEntry entry =
                    CheckoutController.to.order.items.entries.elementAt(index);
                return _buildCheckoutItem(entry.key, entry.value);
              },
            ),
            bottomSheet: _buildFooter(CheckoutController.to.order),
          ));
  }

  Widget _buildCheckoutItem(Product product, int amount) {
    return Slidable(
      key: ValueKey(product.name),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async => CheckoutController.to.addItem(product),
            autoClose: false,
            label: "Erhöhen",
            icon: Icons.add,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: (_) async => CheckoutController.to.removeItem(product),
            autoClose: false,
            label: "Verringern",
            icon: Icons.remove,
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => _onDelete(product),
        ),
        children: [
          SlidableAction(
            onPressed: (_) => _onDelete(product),
            label: "Löschen",
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ],
      ),
      child: ListTile(
        title: Text(
          product.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("$amount x ${product.price.toStringAsFixed(2)}€"),
        trailing: Text("${(product.price * amount).toStringAsFixed(2)}€"),
      ),
    );
  }

  void _onDelete(Product product) => Utils.showConfirmDialog(
        "Wollen Sie das Produkt wirklich löschen?",
        () async => CheckoutController.to.removeProduct(product),
      );

  Widget _buildFooter(Order order) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            "Gesamt: ${order.total.toStringAsFixed(2)}€",
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.payments),
            label: const Text("Bezahlen"),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              Get.to(() => const CheckoutPage());
            },
          ),
        ],
      ),
    );
  }
}
