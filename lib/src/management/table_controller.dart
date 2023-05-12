import 'package:get/get.dart';

import 'api_service.dart';
import 'state_service.dart';
import '../data/table.dart';

/// A class to read and update the tables.
class TableController extends GetxController {
  final RxList<Table> tables = StateService.to.tables;

  TableController();

  static TableController get to => Get.find<TableController>();

  @override
  void onClose() {
    StateService.to.syncState();
    super.onClose();
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> addNTables(int n) async {
    if (n <= 0) return;

    // Update observable
    for (int i = 0; i < n; i++) {
      // Create data in database
      var response = await APIService.to.addTable();
      Table table = Table.fromJson(response);

      // Save data in memory
      tables.add(table);
    }
  }

  /// Add and persist a new product based on the user's inputs.
  Future<void> deleteNTables(int n) async {
    if (n <= 0) return;

    var rTables = List.from(tables.where((t) => t.number > tables.length - n));
    // Update observable
    for (var table in rTables) {
      // Delete data from database
      await APIService.to.deleteTable(table.id);

      // Remove data from memory
      tables.remove(table);
    }
  }
}
