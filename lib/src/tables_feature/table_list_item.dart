import 'package:bestellbuch/src/routes.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '../order_feature/checkout_controller.dart';
import 'table.dart';

class TableListItem extends StatelessWidget {
  final Table table;
  final TableGroup group;

  const TableListItem({super.key, required this.table, required this.group});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          child: ListTile(
            title: Text(table.name),
            onTap: () {
              if (Get.isRegistered<CheckoutController>()) {
                return Get.back(result: table);
              }

              Get.toNamed(
                Routes.checkout,
                arguments: table,
              );
            },
            trailing: !table.isAvailable ? const Icon(Icons.restaurant) : null,
          ),
        ));
  }
}
