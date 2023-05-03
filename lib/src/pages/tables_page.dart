import 'package:bestellbuch/src/table_feature/table_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/main_controller.dart';
import '../table_feature/table_list_item.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: TableAppBar(),
        body: MainController.to.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: MainController.to.tables.length,
                itemBuilder: (_, idx) =>
                    TableListItem(table: MainController.to.tables[idx]),
              )));
  }
}
