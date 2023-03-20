import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../catalog_controller.dart';

class CatalogTabBar extends StatelessWidget {
  const CatalogTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: CatalogController.to.roots
              .map((catalog) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.5,
                            color: catalog == CatalogController.to.current
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => CatalogController.to.select(catalog),
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
