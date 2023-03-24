import 'package:get/get.dart';

import 'tables_controller.dart';
import 'tables_service.dart';

class TablesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TablesController(TablesService()));
  }
}
