import 'package:flutter/material.dart' hide Table;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../management/main_controller.dart';

class TableAppBarButton extends StatefulWidget {
  const TableAppBarButton({super.key});

  @override
  State<TableAppBarButton> createState() => _TableAppBarButtonState();
}

class _TableAppBarButtonState extends State<TableAppBarButton> {
  int _pickerValue = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Get.defaultDialog(
              titlePadding: const EdgeInsets.symmetric(vertical: 22.0),
              title: "Tische anpassen",
              content: StatefulBuilder(
                builder: (_, setState) => NumberPicker(
                  minValue: 0,
                  maxValue: 50,
                  value: _pickerValue,
                  onChanged: (value) => setState(() => _pickerValue = value),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    MainController.to.addNTables(_pickerValue);
                    Get.back();
                  },
                  child: const Text("Hinzufügen"),
                ),
                TextButton(
                  onPressed: () {
                    MainController.to.deleteNTables(_pickerValue);
                    Get.back();
                  },
                  child: const Text("Löschen"),
                ),
              ],
            ),
        icon: const Icon(FontAwesomeIcons.plusMinus));
  }
}
