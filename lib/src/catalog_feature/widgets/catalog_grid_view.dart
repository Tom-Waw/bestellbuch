import 'package:flutter/material.dart';

import '../catalog_controller.dart';
import 'catalog_item_box.dart';

class CatalogGridView extends StatelessWidget {
  final CatalogController controller;

  const CatalogGridView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        restorationId: "catalogGridView",
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: [
          if (!controller.isRoot)
            InkWell(
              onTap: () => controller.back(),
              child: Ink(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.arrow_back)),
              ),
            ),
          ...controller.current.items
              .map((item) => CatalogItemBox(item: item, controller: controller))
              .toList(),
          InkWell(
            onTap: () {},
            child: Ink(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.add)),
            ),
          )
        ]);
  }
}
