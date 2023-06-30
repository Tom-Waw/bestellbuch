import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'order_service.dart';
import '../employees_feature/employee.dart';

class EmployeeService extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Employees");

  static EmployeeService get to => Get.find<EmployeeService>();

  final RxList<Employee> employees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    employees.bindStream(_dbStream());
  }

  @override
  void onClose() {
    super.onClose();
    employees.close();
  }

  Stream<List<Employee>> _dbStream() =>
      _ref.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Employee.fromJson(doc.id, doc.data()))
          .toList());

  String? _checkName(String name, {Employee? employee}) {
    if (name.isEmpty) return "Bitte geben Sie einen Namen an";
    if (employees.any(
      (employee) => employee.name == name && employee != employee,
    )) {
      return "Mitarbeiter mit diesem Namen existiert bereits";
    }
    return null;
  }

  Future<String?> addEmployee({required String name}) async {
    String? error = _checkName(name);
    if (error != null) return error;

    Employee employee = Employee(
      id: _ref.doc().id,
      name: name,
    );
    await _ref.doc(employee.id).set(employee.toJson());
    return null;
  }

  Future<String?> updateEmployee(Employee employee) async {
    String? error = _checkName(employee.name, employee: employee);
    if (error != null) return error;

    await _ref.doc(employee.id).update(employee.toJson());
    return null;
  }

  Future<String?> deleteEmployee(Employee employee) async {
    if (OrderService.to.orders.any((o) => o.waiter == employee)) {
      return "Mitarbeiter hat noch aktive Bestellungen";
    }
    await _ref.doc(employee.id).delete();
    return null;
  }
}
