import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../catalog_controller.dart';
import '../catalog.dart';

class CatalogTabBar extends StatelessWidget {
  const CatalogTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CatalogController>();

    return Obx(() => Row(
          children: controller.root.value.parent.items
              .cast<Catalog>()
              .map((catalog) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.5,
                            color: catalog == controller.root.value
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => controller.select(catalog),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(children: [
                            Icon(catalog.icon, color: Colors.white),
                            const SizedBox(height: 6.0),
                            Text(
                              catalog.name,
                              style: const TextStyle(color: Colors.white),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ));
  }
}
