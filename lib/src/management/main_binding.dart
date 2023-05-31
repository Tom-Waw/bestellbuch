import 'package:get/get.dart';

import '../auth/auth_service.dart';
import 'api_service.dart';
import 'state_service.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(AuthService(), permanent: true);
    Get.put(APIService(), permanent: true);
    Get.put(StateService(), permanent: true);
  }
}
