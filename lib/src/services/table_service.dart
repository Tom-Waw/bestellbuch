import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../tables_feature/table.dart';
import 'order_service.dart';

/// A class to read and update the tables.
class TableService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Tables");

  static TableService get to => Get.find<TableService>();

  final RxList<TableGroup> tableGroups = <TableGroup>[].obs;
  List<Table> get allTables => tableGroups.expand((g) => g.tables).toList();

  @override
  void onInit() {
    super.onInit();
    tableGroups.bindStream(_dbStream());
  }

  @override
  void onClose() {
    super.onClose();
    tableGroups.close();
  }

  Stream<List<TableGroup>> _dbStream() =>
      _ref.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => TableGroup.fromJson(doc.id, doc.data()))
          .toList());

  String? _checkName(String name, {TableGroup? group}) {
    if (name.isEmpty) return "Bitte geben Sie einen Namen an";
    if (tableGroups.any((g) => g.name == name && g.id != group?.id)) {
      return "Dieser Name existiert bereits";
    }
    return null;
  }

  /// Add and persist n new tables.
  Future<String?> addGroup({required String name, required int size}) async {
    String? error = _checkName(name);
    if (error != null) return error;

    final group = TableGroup(
      id: _ref.doc().id,
      name: name,
      size: size,
    );
    await _ref.doc(group.id).set(group.toJson());
    return null;
  }

  // Update an existing group of tables.
  Future<String?> updateGroup(int size, TableGroup group) async {
    String? error = _checkName(group.name, group: group);
    if (error != null) return error;

    if (size <= group.tables.length) {
      bool test(Table t) => t.number > size;
      final tablesToDelete = group.tables.where(test);
      if (OrderService.to.orders.any(
        (o) => tablesToDelete.contains(o.table),
      )) {
        return "Es gibt noch aktive Bestellungen unter den zu löschenden Tischen.";
      }

      group.tables.removeWhere(test);
    } else {
      group.tables.addAll(List.generate(
        size - group.tables.length,
        (idx) => Table(
          group: group,
          number: group.tables.length + idx + 1,
        ),
      ));
    }

    await _ref.doc(group.id).set(group.toJson());
    return null;
  }

  // Delete an existing group of tables.
  Future<String?> deleteGroup(group) async {
    if (OrderService.to.orders.any(
      (order) => order.table.group == group,
    )) {
      return "Es gibt noch aktive Bestellungen unter den zu löschenden Tischen.";
    }

    await _ref.doc(group.id).delete();
    return null;
  }
}
