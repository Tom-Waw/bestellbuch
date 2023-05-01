import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class MenuItem {
  Menu? _parent;
  final String name;

  MenuItem({required this.name});

  Menu get parent => _parent!;
  void setParent(Menu parent) {
    _parent = parent;
  }
}

class Menu extends MenuItem {
  final List<MenuItem> items;

  Menu({required super.name, required this.items}) {
    for (MenuItem item in items) {
      item._parent = this;
    }
  }

  Menu? getRoot() {
    if (_parent == null) return null;
    if (_parent?._parent == null) return this;
    return _parent?.getRoot();
  }

  factory Menu.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    var data = snapshot.data()!;

    print(data);
    return Menu(name: data['name'], items: data["items"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "items": items,
    };
  }
}

class Product extends MenuItem {
  final double price;

  Product({required super.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(name: json["name"], price: json["price"]);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
    };
  }
}
