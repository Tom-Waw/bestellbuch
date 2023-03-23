import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'catalog_feature/catalog_binding.dart';
import 'catalog_feature/catalog_page.dart';

/// The Widget that configures your application.
class BestellBuchApp extends StatelessWidget {
  const BestellBuchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Bestellbuch",
      navigatorKey: GlobalKey(debugLabel: "app"),
      theme: ThemeData(),
      getPages: [
        GetPage(
          name: "/home",
          page: () => const CatalogPage(),
          binding: CatalogBinding(),
        ),
      ],
      initialRoute: "/home",
    );
  }
}
