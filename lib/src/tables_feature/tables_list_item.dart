import 'package:bestellbuch/src/routes.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import 'table.dart';

class TablesListItem extends StatelessWidget {
  final Table table;

  const TablesListItem({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14.0),
        title: Text(
          table.name,
          style: const TextStyle(fontSize: 18.0),
        ),
        onTap: () => Get.toNamed(
          Routes.checkout,
          arguments: table,
        ),
      ),
    );
  }
}
