import 'package:get/get.dart';

import 'home_page.dart';
import '../catalog_feature/catalog_binding.dart';
import '../catalog_feature/catalog_page.dart';
import '../tables_feature/tables_page.dart';
import '../tables_feature/tables_binding.dart';

class Routes {
  static String home = '/home';
  static String catalog = '/catalog';
  static String tables = '/tables';
}

final getPages = [
  GetPage(
    name: Routes.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.catalog,
    page: () => const CatalogPage(),
    binding: CatalogBinding(),
  ),
  GetPage(
    name: Routes.tables,
    page: () => const TablesPage(),
    binding: TablesBinding(),
  ),
];
