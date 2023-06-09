import 'package:flutter/material.dart' hide Table;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../auth/auth_service.dart';
import 'table_service.dart';

class TablesAppBar extends AppBar {
  TablesAppBar({super.key});

  @override
  State<TablesAppBar> createState() => _TableAppBarState();
}

class _TableAppBarState extends State<TablesAppBar> {
  int _pickerValue = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBar(
          title: const Text("Tischplan"),
          actions: [
            if (AuthService.to.isAdmin)
              IconButton(
                icon: const Icon(FontAwesomeIcons.plusMinus),
                onPressed: () => Get.defaultDialog(
                  titlePadding: const EdgeInsets.symmetric(vertical: 22.0),
                  title: "Tische anpassen",
                  content: StatefulBuilder(
                    builder: (_, setState) => NumberPicker(
                      minValue: 0,
                      maxValue: 50,
                      value: _pickerValue,
                      onChanged: (value) =>
                          setState(() => _pickerValue = value),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await TableService.to.addNTables(_pickerValue);
                        Get.back();
                      },
                      child: const Text("Hinzufügen"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await TableService.to.deleteNTables(_pickerValue);
                        Get.back();
                      },
                      child: const Text("Löschen"),
                    ),
                  ],
                ),
              )
          ],
        ));
  }
}
