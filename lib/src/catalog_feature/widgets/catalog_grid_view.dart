import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../catalog_controller.dart';
import 'catalog_item_box.dart';

class CatalogGridView extends StatelessWidget {
  const CatalogGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CatalogController>();

    return Obx(() => GridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: [
              if (!controller.isRoot.value)
                InkWell(
                  onTap: () => controller.back(),
                  child: Ink(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
              ...controller.current.value.items
                  .map((item) => CatalogItemBox(item: item))
                  .toList(),
              InkWell(
                onTap: () {},
                child: Ink(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.add)),
                ),
              )
            ]));
  }
}
