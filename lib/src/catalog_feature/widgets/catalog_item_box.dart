import 'package:flutter/material.dart';

import '../catalog_controller.dart';
import '../catalog.dart';

class CatalogItemBox extends StatelessWidget {
  final CatalogItem item;

  const CatalogItemBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CatalogController.to.select(item),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.name, textAlign: TextAlign.center),
            if (item is Product) ...[
              const SizedBox(height: 5),
              Text(
                "${(item as Product).price.toStringAsFixed(2)} €",
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
