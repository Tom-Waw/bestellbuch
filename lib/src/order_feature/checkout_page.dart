import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'checkout_controller.dart';
import 'order_selection_view.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text("Bestellung abschließen"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 30.0),
            child: OrderSelectionView(
              order: CheckoutController.to.order,
              onSubmit: (selection) async {
                await CheckoutController.to.checkout(selection);

                // TODO: print receipt
              },
            ),
          ),
        ));
  }
}
