import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Table;

import '../data/menu.dart';
import '../data/store.dart';
import '../data/table.dart';

class APIService {
  Future<Store> fetchData() async {
    var db = FirebaseFirestore.instance;

    var menu = db.collection("Menu").where("name", isEqualTo: "root");
    var tables = db.collection("Tables");

    return Store(menu as Menu, tables as List<Table>);
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
