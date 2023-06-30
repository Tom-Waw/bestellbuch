import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../shared/utils.dart';
import '../services/table_service.dart';
import 'table.dart';
import 'table_form.dart';
import 'table_list_item.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tischplan"),
          centerTitle: true,
          actions: [
            if (!AuthService.to.isAdmin)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => AuthService.to.logout(),
              ),
            if (AuthService.to.isAdmin)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Utils.showBottomSheet(
                  "Tischgruppe hinzufügen",
                  const TableForm(),
                ),
              ),
          ],
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: TableService.to.tableGroups.length,
            itemBuilder: (_, idx) =>
                _buildGroupTile(TableService.to.tableGroups[idx]),
          ),
        ));
  }

  Widget _buildGroupTile(TableGroup group) => Card(
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(14.0),
          title: Text(
            group.name,
            style: const TextStyle(fontSize: 18.0),
          ),
          trailing: AuthService.to.isAdmin
              ? IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Utils.showBottomSheet(
                    "Tischgruppe anpassen",
                    TableForm(group: group),
                  ),
                )
              : null,
          children: [
            const Divider(thickness: 2.0),
            ...group.tables.map(
              (table) => TableListItem(
                table: table,
                group: group,
              ),
            )
          ],
        ),
      );
}
