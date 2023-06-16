import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../order_feature/order_service.dart';
import 'table.dart';

/// A class to read and update the tables.
class TableService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Tables");

  static TableService get to => Get.find<TableService>();

  final RxList<TableGroup> tableGroups = <TableGroup>[].obs;

  @override
  void onInit() {
    super.onInit();
    tableGroups.bindStream(_dbStream());
  }

  Stream<List<TableGroup>> _dbStream() =>
      _ref.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => TableGroup.fromJson(doc.id, doc.data()))
          .toList());

  /// Add and persist n new tables.
  Future<String?> addNTables(int n, TableGroup group) async {
    if (n <= 0) return "Anzahl der Tische muss größer als 0 sein.";

    await _ref.doc(group.id).update({"number": group.tables.length + n});
    return null;
  }

  /// Delete last n tables.
  Future<String?> deleteNTables(int n, TableGroup group) async {
    if (n <= 0) return "Anzahl der Tische muss größer als 0 sein.";

    if (OrderService.to.activeOrders
        .any((order) => group.tables.contains(order.table))) {
      return "Es gibt noch aktive Bestellungen unter den zu löschenden Tischen.";
    }

    await _ref
        .doc(group.id)
        .update({"number": max(group.tables.length - n, 0)});
    return null;
  }
}
