import 'package:flutter/material.dart';

import 'catalog_feature/catalog_controller.dart';
import 'catalog_feature/catalog_page.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_page.dart';

/// The Widget that configures your application.
class BestellBuchApp extends StatelessWidget {
  final SettingsController settingsController;
  final CatalogController catalogController;

  const BestellBuchApp({
    super.key,
    required this.settingsController,
    required this.catalogController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          title: "Bestellbuch",
          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsPage.routeName:
                    return SettingsPage(controller: settingsController);
                  case CatalogPage.routeName:
                  default:
                    return CatalogPage(controller: catalogController);
                }
              },
            );
          },
        );
      },
    );
  }
}
