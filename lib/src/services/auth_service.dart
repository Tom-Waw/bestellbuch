import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../employees_feature/employee.dart';
import 'employee_service.dart';
import '../routes.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;

  static AuthService get to => Get.find<AuthService>();

  late final Rx<User?> firebaseUser;

  final Rxn<String> _employeeId = Rxn<String>();

  @override
  void onInit() async {
    super.onInit();

    firebaseUser = _auth.currentUser.obs;
    firebaseUser.bindStream(_auth.userChanges());

    ever(firebaseUser, _onAuthStateChanged);
    ever(_employeeId, _onAuthStateChanged);
  }

  @override
  void onClose() {
    super.onClose();
    firebaseUser.close();
  }

  void _onAuthStateChanged(dynamic user) {
    if (user == null &&
        Get.currentRoute != Routes.login &&
        Get.currentRoute != Routes.splash) {
      Get.offAllNamed(Routes.login);
    }
  }

  bool get isAdmin => firebaseUser.value != null;

  bool get isLoggedIn => _employeeId.value != null;
  Employee get employee => EmployeeService.to.employees
      .firstWhere((e) => e.id == _employeeId.value!);

  void loginAsEmployee(Employee employee) {
    employee.active = true;
    EmployeeService.to.updateEmployee(employee);
    _employeeId.value = employee.id;
  }

  Future<String?> loginAsAdmin(String name, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: "$name@user.com",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return "Error: Versuch es später nochmal.";
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();

    if (isLoggedIn) {
      employee.active = false;
      EmployeeService.to.updateEmployee(employee);
      _employeeId.value = null;
    }
  }
}
