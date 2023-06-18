import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import '../services/auth_service.dart';
import '../services/employee_service.dart';
import '../services/menu_service.dart';
import '../services/order_service.dart';
import '../services/table_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initServices();
  }

  void _initServices() async {
    Get.put(EmployeeService(), permanent: true);
    Get.put(TableService(), permanent: true);
    await Get.putAsync(MenuService().init, permanent: true);
    Get.put(OrderService(), permanent: true);
    Get.put(AuthService(), permanent: true);

    Get.offAllNamed(Routes.initial);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
