import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/management/main_binding.dart';
import 'src/routes/routes.dart';

void main() async {
  runApp(const App());
}

/// The Widget that configures your application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Bestellbuch",
      navigatorKey: GlobalKey(debugLabel: "app"),
      theme: ThemeData(),
      getPages: getPages,
      initialRoute: Routes.home,
      initialBinding: MainBinding(),
    );
  }
}
