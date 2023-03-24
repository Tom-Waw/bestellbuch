import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/routes.dart';

/// The Widget that configures your application.
class BestellBuchApp extends StatelessWidget {
  const BestellBuchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Bestellbuch",
      navigatorKey: GlobalKey(debugLabel: "app"),
      theme: ThemeData(),
      getPages: getPages,
      initialRoute: Routes.home,
    );
  }
}
