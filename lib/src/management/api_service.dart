import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class APIService {
  final tableRef = FirebaseFirestore.instance.collection("Tables");
  final menuRef = FirebaseFirestore.instance
      .collection("Menu")
      .where("name", isEqualTo: "root");

  Future<Map<String, dynamic>> fetchData() async {
    var menus = await _loadMenu(await menuRef.get());
    var tables = _loadTables(await tableRef.orderBy("number").get());

    return {
      "menus": menus.first["items"],
      "tables": tables,
    };
  }

  Future<List<Map<String, dynamic>>> _loadMenu(
          QuerySnapshot<Map<String, dynamic>> ref) =>
      Future.wait(ref.docs.map((menu) async {
        var data = menu.data();
        data["id"] = menu.id;

        if (data.containsKey("price")) return data;

        var innerRef =
            await menu.reference.collection("items").orderBy("name").get();
        data["items"] = await _loadMenu(innerRef);

        return data;
      }));

  List<Map<String, dynamic>> _loadTables(
          QuerySnapshot<Map<String, dynamic>> ref) =>
      ref.docs.map((table) {
        var data = table.data();
        data["id"] = table.id;

        return data;
      }).toList();

  Future<Map<String, dynamic>> addTable() async {
    int tablesCount = (await tableRef.count().get()).count;
    var ref = await tableRef.add({
      "number": tablesCount + 1,
    });

    var data = (await ref.get()).data()!;
    data["id"] = ref.id;
    return data;
  }

  Future<void> deleteTable(String id) async {
    await tableRef.doc(id).delete();
  }
}
