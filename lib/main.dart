import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'src/routes.dart';
import 'src/services/auth_service.dart';
import 'src/services/employee_service.dart';
import 'src/services/menu_service.dart';
import 'src/services/order_service.dart';
import 'src/services/table_service.dart';

void main() async {
  // Initialize Firestore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

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
      initialBinding: BindingsBuilder(() {
        Get.put(EmployeeService(), permanent: true);
        Get.put(TableService(), permanent: true);
        Get.put(MenuService(), permanent: true);
        Get.put(OrderService(), permanent: true);
        Get.put(AuthService(), permanent: true);
      }),
    );
  }
}
