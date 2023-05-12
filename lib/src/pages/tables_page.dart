import 'package:bestellbuch/src/table_feature/table_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/table_controller.dart';
import '../table_feature/table_list_item.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: TableAppBar(),
        body: ListView.builder(
          itemCount: TableController.to.tables.length,
          itemBuilder: (_, idx) =>
              TableListItem(table: TableController.to.tables[idx]),
        )));
  }
}
