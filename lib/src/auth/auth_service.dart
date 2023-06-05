import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../employees_feature/employee.dart';
import '../routes.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;

  static AuthService get to => Get.find<AuthService>();

  late final Rx<User?> firebaseUser;

  final Rx<Employee?> _employee = null.obs;

  @override
  void onInit() async {
    super.onInit();
    await logout();

    firebaseUser = _auth.currentUser.obs;
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, (User? user) {
      if (user == null) Get.offAllNamed(Routes.login);
    });
  }

  bool get isAdmin => firebaseUser.value == null;

  bool get isLoggedIn => _employee.value != null;
  Employee get employee => _employee.value!;

  void loginAsEmployee(Employee employee) => _employee(employee);

  Future<void> loginAsAdmin(String name, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: "$name@user.com",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: "Error: ${e.message}",
      ));
    } catch (_) {
      Get.showSnackbar(const GetSnackBar(
        message: "Error: Please try again later.",
      ));
    }

    if (isAdmin) Get.offAllNamed(Routes.home);
  }

  Future<void> logout() async => await _auth.signOut();
}
