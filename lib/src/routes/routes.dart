import 'package:get/get.dart';

import '../management/menu_controller.dart';
import '../management/order_controller.dart';
import '../management/table_controller.dart';

import '../pages/checkout_page.dart';
import '../pages/home_page.dart';
import '../pages/menu_page.dart';
// import '../pages/print_page.dart';
import '../pages/tables_page.dart';

class Routes {
  static String home = '/home';
  static String menu = '/menu';
  static String tables = '/tables';
  static String checkout = '/checkout';
  static String print = '/print';
}

final getPages = [
  GetPage(
    name: Routes.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.menu,
    page: () => const MenuPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => MenuController());
    }),
  ),
  GetPage(
    name: Routes.tables,
    page: () => const TablesPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => TableController());
    }),
  ),
  GetPage(
    name: Routes.checkout,
    page: () => const CheckoutPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => OrderController());
    }),
  )
  // GetPage(
  //   name: Routes.print,
  //   page: () => PrintPage(),
  // ),
];
