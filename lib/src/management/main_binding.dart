import 'package:get/get.dart';

import 'api_service.dart';
import 'main_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController(APIService()), fenix: true);
  }
}
