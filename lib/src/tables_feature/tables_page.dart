import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../auth/auth_service.dart';
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
          if (AuthService.to.isAdmin)
            IconButton(
              icon: const Icon(FontAwesomeIcons.plusMinus),
              onPressed: () => Get.bottomSheet(
                _buildBottomSheet(),
                backgroundColor: Colors.white,
              ),
            )
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: TableService.to.tables.length,
            itemBuilder: (_, idx) =>
                TableListItem(table: TableService.to.tables[idx]),
          )),
    );
  }

  Widget _buildBottomSheet() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tische anpassen", style: TextStyle(fontSize: 20.0)),
            Expanded(
              child: Center(
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
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await TableService.to.addNTables(_pickerValue);
                      Get.back();
                    },
                    child: const Text("Hinzufügen"),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await TableService.to.deleteNTables(_pickerValue);
                      Get.back();
                    },
                    child: const Text("Löschen"),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
