import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../order_feature/order_service.dart';
import 'table.dart';

/// A class to read and update the tables.
class TableService extends GetxService {
  final _ref = FirebaseFirestore.instance.collection("Tables");

  static TableService get to => Get.find<TableService>();

  final RxList<TableGroup> _tableGroups = <TableGroup>[].obs;
  List<Table> get tables =>
      _tableGroups.isNotEmpty ? _tableGroups.first.tables : [];

  @override
  void onInit() {
    super.onInit();
    _tableGroups.bindStream(_dbStream());
  }

  Stream<List<TableGroup>> _dbStream() =>
      _ref.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => TableGroup.fromJson(doc.id, doc.data()))
          .toList());

  /// Add and persist n new tables.
  Future<String?> addNTables(int n) async {
    if (n <= 0) return "Anzahl der Tische muss größer als 0 sein.";

    await _ref.doc(_tableGroups.first.id).update({"number": tables.length + n});
    return null;
  }

  /// Delete last n tables.
  Future<String?> deleteNTables(int n) async {
    if (n <= 0) return "Anzahl der Tische muss größer als 0 sein.";

    if (OrderService.to.activeOrders
        .any((order) => order.table.number > tables.length - n)) {
      return "Es gibt noch aktive Bestellungen unter den zu löschenden Tischen.";
    }

    await _ref
        .doc(_tableGroups.first.id)
        .update({"number": max(tables.length - n, 0)});
    return null;
  }
}
