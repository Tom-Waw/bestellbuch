import 'package:flutter/material.dart';

import '../catalog_controller.dart';
import '../catalog.dart';

class CatalogTabBar extends StatelessWidget {
  final CatalogController controller;

  const CatalogTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: controller.root.parent.items
          .cast<Catalog>()
          .map((catalog) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.5,
                        color: catalog == controller.root
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
    );
  }
}
