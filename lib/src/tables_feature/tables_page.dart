import 'package:bestellbuch/src/tables_feature/tables_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'table_service.dart';
import 'tables_list_item.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TablesAppBar(),
      body: Obx(() => ListView.builder(
            itemCount: TableService.to.tables.length,
            itemBuilder: (_, idx) =>
                TablesListItem(table: TableService.to.tables[idx]),
          )),
    );
  }
}
