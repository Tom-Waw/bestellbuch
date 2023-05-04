import 'package:get/get.dart';

// import '../pages/checkout_page.dart';
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
  ),
  GetPage(
    name: Routes.tables,
    page: () => const TablesPage(),
  ),
  // GetPage(
  //   name: Routes.print,
  //   page: () => PrintPage(),
  // ),
];
