import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'src/routes.dart';

void main() async {
  // Initialize Firestore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialRoute: Routes.splash,
    );
  }
}
