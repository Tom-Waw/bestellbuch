import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../employees_feature/employee.dart';
import '../employees_feature/employee_service.dart';
import '../routes.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;

  static AuthService get to => Get.find<AuthService>();

  late final Rx<User?> firebaseUser;

  final Rxn<Employee> _employee = Rxn<Employee>();

  @override
  void onInit() async {
    super.onInit();
    await logout();

    firebaseUser = _auth.currentUser.obs;
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, (User? user) {
      if (user == null && Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    });
  }

  bool get isAdmin => firebaseUser.value != null;

  bool get isLoggedIn => _employee.value != null;
  Employee get employee => _employee.value!;

  void loginAsEmployee(Employee employee) {
    employee.active = true;
    EmployeeService.to.updateEmployee(employee);
    _employee.value = employee;
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
      return "Error: Please try again later.";
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();

    if (isLoggedIn) {
      employee.active = false;
      EmployeeService.to.updateEmployee(employee);
      _employee.value = null;
    }
  }
}
