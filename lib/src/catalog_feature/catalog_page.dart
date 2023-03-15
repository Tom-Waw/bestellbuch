import 'package:flutter/material.dart';

import 'widgets/catalog_grid_view.dart';
import 'widgets/catalog_tabbar.dart';
import 'catalog_controller.dart';

/// Displays the product catalog that is managed by the admin.
class CatalogPage extends StatelessWidget {
  static const routeName = '/catalog';

  final CatalogController controller;

  const CatalogPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CatalogTabBar(controller: controller),
        ),
      ),
      body: CatalogGridView(controller: controller),
    );
  }
}
