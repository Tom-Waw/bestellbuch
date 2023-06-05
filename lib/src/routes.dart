import 'package:get/get.dart';

import 'auth/login_page.dart';

import 'menu_feature/menu_controller.dart';
import 'menu_feature/menu_page.dart';

import 'order_feature/order_controller.dart';
import 'order_feature/checkout_page.dart';

import 'auth/home_page.dart';

import 'tables_feature/tables_controller.dart';
import 'tables_feature/tables_page.dart';

import 'employees_feature/employees_controller.dart';
import 'employees_feature/employees_page.dart';

class Routes {
  static String login = '/login';
  static String home = '/home';
  static String employees = '/employees';
  static String tables = '/tables';
  static String menu = '/menu';
  static String checkout = '/checkout';
  static String print = '/print';
}

final getPages = [
  GetPage(
    name: Routes.login,
    page: () => const LoginPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => EmployeesController());
    }),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.employees,
    page: () => const EmployeesPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => EmployeesController());
    }),
  ),
  GetPage(
    name: Routes.tables,
    page: () => const TablesPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => TablesController());
    }),
  ),
  GetPage(
    name: Routes.menu,
    page: () => const MenuPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => MenuController());
    }),
  ),
  GetPage(
    name: Routes.checkout,
    page: () => const CheckoutPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => MenuController());
      Get.lazyPut(() => OrderController());
    }),
  )
  // GetPage(
  //   name: Routes.print,
  //   page: () => PrintPage(),
  // ),
];
