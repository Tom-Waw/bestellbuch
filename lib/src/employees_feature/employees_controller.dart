import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'employee.dart';

class EmployeesController extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Employees");

  static EmployeesController get to => Get.find<EmployeesController>();

  final RxList<Employee> employees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    employees.bindStream(_dbStream());
  }

  Stream<List<Employee>> _dbStream() => _ref
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  Future<void> addEmployee(String name) async {
    if (name.isEmpty) return;

    await _ref.doc(name).set({});
  }

  Future<void> deleteEmployee(String name) async {
    if (name.isEmpty) return;

    await _ref.doc(name).delete();
  }
}
