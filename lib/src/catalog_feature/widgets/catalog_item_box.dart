import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../catalog_controller.dart';
import '../catalog.dart';

class CatalogItemBox extends StatelessWidget {
  final CatalogItem item;

  const CatalogItemBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CatalogController>();

    return GestureDetector(
      onTap: () => controller.select(item),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: Center(child: Text(item.name, textAlign: TextAlign.center)),
      ),
    );
  }
}
