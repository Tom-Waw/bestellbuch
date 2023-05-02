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
      .where("name", isEqualTo: "root");

  Future<Store> fetchData() async {
    var menus = await _loadMenu(await menuRef.get());
    var tables = await tableRef.get();

    return Store(
      menus.cast<Menu>().first.items.cast<Menu>(),
      tables.docs.map((t) => t.data()).toList(),
    );
  }

  Future<List<MenuItem>> _loadMenu(QuerySnapshot<Map<String, dynamic>> ref) =>
      Future.wait(ref.docs.map((menu) async {
        Map<String, dynamic> data = menu.data();

        if (data.containsKey("price")) return Product.fromJson(data);

        var innerRef = await menu.reference.collection("items").get();
        data["items"] = await _loadMenu(innerRef);

        return Menu.fromJson(data);
      }));

  Future<void> addToMenu(MenuItem? item) async {
    if (item is Product) {
      //item.name
      //item.price
      //item.parent
    }

    if (item is Menu) {}
  }
}
