import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '../data/table.dart';
import '../management/main_controller.dart';
import '../routes/routes.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key, required Table table}) {
    MainController.to.openTable(table);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainController.to.isLoading.value
        ? Scaffold(
            appBar: AppBar(title: const Text("Bestellung")),
            body: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(MainController.to.order!.table.name),
              backgroundColor: Colors.redAccent,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: MainController.to.order!.items.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(
                          MainController.to.order!.items.keys
                              .elementAt(index)
                              .name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(""
                            "${MainController.to.order!.items.values.elementAt(index)} x "
                            "${MainController.to.order!.items.keys.elementAt(index).price}"),
                        trailing: Text(
                          "€ ${MainController.to.order!.items.keys.elementAt(index).price * MainController.to.order!.items.values.elementAt(index)}",
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        "Total: ${MainController.to.order!.total}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 80),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Get.toNamed(Routes.print);
                          },
                          icon: const Icon(Icons.print),
                          label: const Text('Print'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
  }
}
