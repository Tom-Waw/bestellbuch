import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/menu.dart';
import '../data/store.dart';
import '../data/table.dart';

class APIService {
  final tableRef = FirebaseFirestore.instance
      .collection("Tables")
      .withConverter<Table>(
          fromFirestore: Table.fromFirestore,
          toFirestore: (table, _) => table.toFirestore());

  final menuRef = FirebaseFirestore.instance
      .collection("Menu")
      .withConverter<Menu>(
          fromFirestore: (snapshot, _) => Menu.fromJson(snapshot.data()!),
          toFirestore: (menu, _) => menu.toJson())
      .where("name", isEqualTo: "root");

  Future<Store> fetchData() async {
    var menu = await menuRef.get();
    var tables = await tableRef.get();

    return Store(
      menu.docs.map((m) => m.data()).toList(),
      tables.docs.map((t) => t.data()).toList(),
    );
  }

  Future<void> addToMenu(MenuItem? item) async {
    if (item is Product) {
      //item.name
      //item.price
      //item.parent
    }

    if (item is Menu) {}
  }
}
