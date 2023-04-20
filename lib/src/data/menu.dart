import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class MenuItem {
  Menu? _parent;
  final String name;

  MenuItem(this.name);

  Menu get parent => _parent!;
  void setParent(Menu parent) {
    _parent = parent;
  }
}

class Menu extends MenuItem {
  final IconData? icon;
  final List<MenuItem> items;

  Menu(super.name, this.items, {this.icon}) {
    for (MenuItem item in items) {
      item._parent = this;
    }
  }

  Menu? getRoot() {
    if (_parent == null) return null;
    if (_parent?._parent == null) return this;
    return _parent?.getRoot();
  }

  factory Menu.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    var items = data?['items'] is Iterable ? List.from(data?['items']) : null,
    items = items.map((item) => item.containsKey("price")? Product.fromFirestore(snapshot, options))
    return Menu(
      name: data?['name'],
      items:
          data?['items'] is Iterable ? List.from(data?['items']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (items != null) "items": items,
    };
  }
}

class Product extends MenuItem {
  final double price;

  Product(super.name, this.price);

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Product(
      name: data?['name'],
      price: data?['price'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (price != null) "price": price,
    };
  }
}
