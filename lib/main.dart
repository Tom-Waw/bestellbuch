import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'src/auth/auth_service.dart';
import 'src/employees_feature/employee_service.dart';
import 'src/menu_feature/menu_service.dart';
import 'src/order_feature/order_service.dart';
import 'src/routes.dart';
import 'src/tables_feature/table_service.dart';

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
      initialRoute: Routes.login,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService(), permanent: true);
        Get.put(TableService(), permanent: true);
        Get.put(MenuService(), permanent: true);
        Get.put(OrderService(), permanent: true);
        Get.put(EmployeeService(), permanent: true);
      }),
    );
  }
}
