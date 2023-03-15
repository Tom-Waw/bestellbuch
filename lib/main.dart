import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/catalog_feature/catalog_controller.dart';
import 'src/catalog_feature/catalog_service.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the Controllers, which will glue key functionality to multiple Flutter Widgets.
  final settingsController = SettingsController(SettingsService());
  final catalogController = CatalogController(CatalogService());

  // Load the necessary data while the splash screen is displayed.
  await settingsController.loadSettings();
  await catalogController.loadCatalog();

  // Run the app and pass in the Controllers. The app listens to the
  // Controllers for changes, then passes it further down to the
  // Pages and Widgets.
  runApp(BestellBuchApp(
    settingsController: settingsController,
    catalogController: catalogController,
  ));
}
