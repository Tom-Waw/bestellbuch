import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../auth/auth_service.dart';
import '../shared/add_delete_buttons.dart';
import '../shared/utils.dart';
import 'table_service.dart';
import 'table_list_item.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  int _pickerValue = 0;

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
                icon: const Icon(FontAwesomeIcons.plusMinus),
                onPressed: () => Utils.showBottomSheet(
                  "Tische anpassen",
                  _buildBottomSheet(),
                ),
              )
          ],
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: TableService.to.tableGroups.length,
            itemBuilder: (_, idx) => ExpansionTile(
              title: Text(TableService.to.tableGroups[idx].name),
              children: [
                ...TableService.to.tableGroups[idx].tables
                    .map((table) => TableListItem(table: table))
              ],
            ),
          ),
        ));
  }

  Widget _buildBottomSheet() => Column(children: [
        Center(
          child: StatefulBuilder(
            builder: (_, setState) => NumberPicker(
              axis: Axis.horizontal,
              minValue: 0,
              maxValue: 50,
              value: _pickerValue,
              onChanged: (value) => setState(() => _pickerValue = value),
            ),
          ),
        ),
        AddDeleteButtons(
          onAdd: _onAdd,
          onDelete: _onDelete,
          deleteText: _pickerValue > 0 && TableService.to.tables.isNotEmpty
              ? "Löschen"
              : "Abbrechen",
        ),
      ]);

  void _onAdd() async {
    await TableService.to.addNTables(_pickerValue);
    Get.back();
  }

  void _onDelete() {
    if (TableService.to.tables.isEmpty || _pickerValue == 0) {
      return;
    }

    Utils.showConfirmDialog(
      "Möchten Sie die Tische wirklich löschen?",
      () async => await TableService.to.deleteNTables(_pickerValue),
    );
  }
}
