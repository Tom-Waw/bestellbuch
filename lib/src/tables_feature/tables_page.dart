import 'package:bestellbuch/src/tables_feature/tables_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tables_controller.dart';
import 'tables_list_item.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: TablesAppBar(),
        body: ListView.builder(
          itemCount: TablesController.to.tables.length,
          itemBuilder: (_, idx) =>
              TablesListItem(table: TablesController.to.tables[idx]),
        )));
  }
}
