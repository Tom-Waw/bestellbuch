import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_bottom_sheet.dart';

class Utils {
  static showBottomSheet(String title, Widget child) => Get.bottomSheet(
        backgroundColor: Colors.white,
        CustomBottomSheet(
          title: title,
          children: [child],
        ),
      );

  static showConfirmDialog(String text, Future<void> Function() onConfirm) =>
      Get.defaultDialog(
        title: text,
        titlePadding: const EdgeInsets.all(25.0).copyWith(bottom: 0.0),
        content: const SizedBox.shrink(),
        contentPadding: const EdgeInsets.all(25.0),
        onConfirm: () async {
          await onConfirm();
          Get.back();
        },
        buttonColor: Colors.red,
        confirmTextColor: Colors.white,
      );
}
