import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../employees_feature/employee.dart';
import 'employee_service.dart';
import '../routes.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;

  static AuthService get to => Get.find<AuthService>();

  late final Rx<User?> _admin;
  final RxnString _currentUserId = RxnString();

  @override
  void onInit() async {
    super.onInit();

    _admin = _auth.currentUser.obs;
    _admin.bindStream(_auth.userChanges());

    ever(_admin, _onAuthStateChanged);
    ever(_currentUserId, _onAuthStateChanged);
  }

  void _onAuthStateChanged(dynamic user) {
    if (user == null &&
        Get.currentRoute != Routes.login &&
        Get.currentRoute != Routes.splash) {
      Get.offAllNamed(Routes.login);
    }
  }

  bool get isAdmin => _admin.value != null;
  bool get isLoggedIn => currentUser != null;

  Employee? get currentUser => EmployeeService.to.employees
      .firstWhereOrNull((e) => e.id == _currentUserId.value);

  void loginAsEmployee(Employee employee) {
    _currentUserId.value ??= employee.id;
  }

  Future<String?> loginAsAdmin(String name, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: "$name@admin.com",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return "Error: Versuch es später nochmal.";
    }
    return null;
  }

  void logout() {
    _auth.signOut();
    _currentUserId.value = null;
  }
}
