import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/menu.dart';
import '../data/store.dart';
import '../data/table.dart';

class APIService {
  Future<Store> fetchData() async {
    var db = FirebaseFirestore.instance;

    //var menu = await db.collection("Menu").where("name", isEqualTo: "root").get();
    var tables = await db
        .collection("Tables")
        .withConverter(
          fromFirestore: Table.fromFirestore,
          toFirestore: (Table table, _) => table.toFirestore(),
        )
        .get();

    print(tables);

    return Store([], tables as List<Table>);
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
