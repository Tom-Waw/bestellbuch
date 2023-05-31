import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  //Variables
  Rx<bool> isReady = false.obs;
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  Rx<bool> isAdmin = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await logout();
    firebaseUser = _auth.currentUser.obs;
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    isReady.value = true;
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<void> refreshIsAdmin() async {
    final uid = firebaseUser.value?.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection("Admin").doc(uid).get();

    isAdmin(snapshot.exists);
  }

  _setInitialScreen(User? user) {
    refreshIsAdmin();
    if (user == null) Get.offAllNamed(Routes.login);
  }

  Future<String?> createUserWithNameAndPassword(
      String name, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: "$name@user.com",
        password: password,
      );
      // firebaseUser.value != null
      //     ? Get.offAll(() => const Dashboard())
      //     : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      return "Error: ${e.message}";
    } catch (_) {
      return "Error: Please try again later.";
    } finally {
      await refreshIsAdmin();
    }
    return null;
  }

  Future<String?> loginWithNameAndPassword(String name, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: "$name@user.com",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return "Error: ${e.message}";
    } catch (_) {
      return "Error: Please try again later.";
    } finally {
      await refreshIsAdmin();
    }
    return null;
  }

  Future<void> logout() async => await _auth.signOut();
}
