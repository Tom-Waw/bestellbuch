import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'catalog_controller.dart';
import 'widgets/catalog_grid_view.dart';
import 'widgets/catalog_tabbar.dart';

/// Displays the product catalog that is managed by the admin.
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CatalogController.to.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text("Menu"),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: CatalogTabBar(),
              ),
            ),
            body: const CatalogGridView(),
          ));
  }
}
