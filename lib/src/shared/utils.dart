import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin Compare<T> implements Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;
  bool operator >=(T other) => compareTo(other) >= 0;
  bool operator <(T other) => compareTo(other) < 0;
  bool operator >(T other) => compareTo(other) > 0;
}

class Utils {
  static showBottomSheet(String title, Widget child) => Get.bottomSheet(
        backgroundColor: Colors.white,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 20.0),
              Expanded(child: child),
            ],
          ),
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
