import 'package:bestellbuch/src/menu_feature/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'checkout_controller.dart';
import 'order.dart';
import 'order_service.dart';
import '../routes.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => !CheckoutController.to.isReady
        ? Scaffold(
            appBar: AppBar(title: const Text("Bestellung")),
            body: const CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(CheckoutController.to.current.table.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    Product product = await Get.toNamed(Routes.menu);
                    CheckoutController.to.addItem(product);
                  },
                ),
                IconButton(
                    onPressed: () => _confirmDeleteDialog(),
                    icon: const Icon(Icons.delete)),
              ],
            ),
            body: ListView.builder(
              itemCount: CheckoutController.to.current.items.length,
              itemBuilder: (_, index) {
                MapEntry entry = CheckoutController.to.current.items.entries
                    .elementAt(index);
                return _buildCheckoutItem(entry.key, entry.value);
              },
            ),
            bottomSheet: _buildFooter(CheckoutController.to.current),
          ));
  }

  Future<void> _confirmDeleteDialog() => Get.defaultDialog(
        title: "Willst du diese Bestellung wirklich löschen?",
        titlePadding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
        middleText: "Diese Aktion kann nicht rückgängig gemacht werden.",
        content: const SizedBox(height: 0.0),
        contentPadding: const EdgeInsets.only(bottom: 20.0),
        onConfirm: () {
          OrderService.to.cancelOrder(CheckoutController.to.current);
          Get.back(closeOverlays: true);
        },
        buttonColor: Colors.red,
        confirmTextColor: Colors.white,
      );

  Widget _buildCheckoutItem(Product product, int amount) {
    return Slidable(
      key: ValueKey(product.name),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => CheckoutController.to.addItem(product),
            label: "Erhöhen",
            icon: Icons.add,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: (_) => CheckoutController.to.removeItem(product),
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
          onDismissed: () => CheckoutController.to.removeProduct(product),
        ),
        children: [
          SlidableAction(
            onPressed: (_) => CheckoutController.to.removeProduct(product),
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
        subtitle: Text("$amount x ${product.price.toStringAsFixed(2)}"),
        trailing: Text("${(product.price * amount).toStringAsFixed(2)}€"),
      ),
    );
  }

  Widget _buildFooter(Order order) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Gesamt: ${order.total.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.print),
            label: const Text("Drucken"),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              CheckoutController.to.checkout();
              Get.back();
              // TODO: print order
            },
          ),
        ],
      ),
    );
  }
}
