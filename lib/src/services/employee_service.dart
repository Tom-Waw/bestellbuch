import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../employees_feature/employee.dart';
import 'order_service.dart';

class EmployeeService extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Employees");
  // ignore: non_constant_identifier_names
  final String _EMPLOYEE_COLLECTION = "employees";

  static EmployeeService get to => Get.find<EmployeeService>();

  final List<StreamSubscription> _subscriptions = [];

  final RxList<EmployeeGroup> groups = <EmployeeGroup>[].obs;
  List<Employee> get allEmployees => groups.expand((g) => g.employees).toList();

  @override
  void onInit() async {
    super.onInit();
    groups.bindStream(_dbStream());
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  Stream<List<EmployeeGroup>> _dbStream() => _ref.snapshots().map((snapshot) {
        final groups = snapshot.docs
            .map((doc) => EmployeeGroup.fromJson(doc.id, doc.data()))
            .toList();

        for (final sub in _subscriptions.toList()) {
          _subscriptions.remove(sub..cancel());
        }

        for (final group in groups) {
          final stream = _employeeStream(group);

          _subscriptions.add(
            stream.listen((employees) {
              group.employees = employees;
              this.groups.refresh();
            }),
          );
        }

        return groups;
      });

  Stream<List<Employee>> _employeeStream(EmployeeGroup group) => _ref
      .doc(group.id)
      .collection(_EMPLOYEE_COLLECTION)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Employee.fromJson(doc.id, group, doc.data()))
          .toList());

  // ? Employees
  String? _checkName(String name, {Employee? employee}) {
    if (name.isEmpty) return "Bitte geben Sie einen Namen an";
    if (allEmployees.any(
      (employee) => employee.name == name && employee != employee,
    )) {
      return "Mitarbeiter mit diesem Namen existiert bereits";
    }
    return null;
  }

  Future<String?> addEmployee(
      {required EmployeeGroup group, required String name}) async {
    String? error = _checkName(name);
    if (error != null) return error;

    Employee employee = Employee(
      id: _ref.doc().id,
      group: group,
      name: name,
    );
    await _ref
        .doc(group.id)
        .collection(_EMPLOYEE_COLLECTION)
        .doc(employee.id)
        .set(employee.toJson());
    return null;
  }

  Future<String?> updateEmployee(Employee employee) async {
    String? error = _checkName(employee.name, employee: employee);
    if (error != null) return error;

    await _ref
        .doc(employee.group.id)
        .collection(_EMPLOYEE_COLLECTION)
        .doc(employee.id)
        .update(employee.toJson());
    return null;
  }

  Future<String?> deleteEmployee(Employee employee) async {
    if (OrderService.to.orders.any((o) => o.waiter == employee)) {
      return "Mitarbeiter hat noch aktive Bestellungen";
    }
    await _ref
        .doc(employee.group.id)
        .collection(_EMPLOYEE_COLLECTION)
        .doc(employee.id)
        .delete();
    return null;
  }

  // ? Employee Groups
  String? _checkGroupName(String name, {EmployeeGroup? group}) {
    if (name.isEmpty) return "Bitte geben Sie einen Namen an";
    if (groups.any((g) => g.name == name && g != group)) {
      return "Gruppe mit diesem Namen existiert bereits";
    }
    return null;
  }

  Future<String?> addGroup({required String name}) async {
    String? error = _checkGroupName(name);
    if (error != null) return error;

    EmployeeGroup group = EmployeeGroup(
      id: _ref.doc().id,
      name: name,
    );
    await _ref.doc(group.id).set(group.toJson());
    return null;
  }

  Future<String?> updateGroup(EmployeeGroup group) async {
    String? error = _checkGroupName(group.name, group: group);
    if (error != null) return error;

    await _ref.doc(group.id).update(group.toJson());
    return null;
  }

  Future<String?> deleteGroup(EmployeeGroup group) async {
    if (group.employees.isNotEmpty) {
      return "Gruppe hat noch Mitarbeiter";
    }
    await _ref.doc(group.id).delete();
    return null;
  }
}
