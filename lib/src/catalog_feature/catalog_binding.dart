import 'package:get/get.dart';

import 'catalog_controller.dart';
import 'catalog_service.dart';

class CatalogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CatalogController(CatalogService()));
  }
}
