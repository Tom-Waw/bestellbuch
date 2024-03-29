import 'package:get/get.dart';

import 'auth/login_page.dart';

import 'auth/splash_screen.dart';
import 'menu_feature/menu_nav_controller.dart';
import 'menu_feature/menu_page.dart';

import 'order_feature/checkout_controller.dart';
import 'order_feature/order_detail_page.dart';

import 'auth/home_page.dart';
import 'tables_feature/tables_page.dart';
import 'employees_feature/employees_page.dart';

class Routes {
  static String splash = '/splash';
  static String initial = login;
  static String login = '/login';
  static String home = '/home';
  static String employees = '/employees';
  static String tables = '/tables';
  static String menu = '/menu';
  static String checkout = '/checkout';
  static String print = '/print';
}

final getPages = [
  GetPage(name: Routes.splash, page: () => const SplashScreen()),
  GetPage(
    name: Routes.login,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.employees,
    page: () => const EmployeesPage(),
  ),
  GetPage(
    name: Routes.tables,
    page: () => const TablesPage(),
  ),
  GetPage(
    name: Routes.menu,
    page: () => const MenuPage(),
    binding: BindingsBuilder.put(() => MenuNavController()),
  ),
  GetPage(
    name: Routes.checkout,
    page: () => const OrderDetailPage(),
    binding: BindingsBuilder.put(() => CheckoutController()),
  )
  // GetPage(
  //   name: Routes.print,
  //   page: () => PrintPage(),
  // ),
];
