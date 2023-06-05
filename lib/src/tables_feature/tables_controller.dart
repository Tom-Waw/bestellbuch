import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'table.dart';

/// A class to read and update the tables.
class TablesController extends GetxController {
  final _ref = FirebaseFirestore.instance.collection("Tables");

  static TablesController get to => Get.find<TablesController>();

  final RxList<TableGroup> _tableGroups = <TableGroup>[].obs;
  List<Table> get tables => _tableGroups.first.tables;

  @override
  void onInit() async {
    super.onInit();
    _tableGroups.bindStream(_dbStream());
  }

  Stream<List<TableGroup>> _dbStream() => _ref.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => TableGroup.fromJson(doc.data())).toList());

  /// Add and persist n new tables.
  Future<void> addNTables(int n) async {
    if (n <= 0) return;

    _ref.doc("default").update({"number": tables.length + n});
  }

  /// Delete last n tables.
  Future<void> deleteNTables(int n) async {
    if (n <= 0) return;

    _ref.doc("default").update({"number": tables.length - n});
  }
}
