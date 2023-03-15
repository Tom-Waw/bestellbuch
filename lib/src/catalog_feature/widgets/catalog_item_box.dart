import 'package:flutter/material.dart';

import '../catalog_controller.dart';
import '../catalog.dart';

class CatalogItemBox extends StatelessWidget {
  final CatalogController controller;
  final CatalogItem item;

  const CatalogItemBox(
      {super.key, required this.controller, required this.item});

  @override
  Widget build(BuildContext context) {
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
