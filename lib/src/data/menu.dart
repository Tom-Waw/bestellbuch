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

  factory Menu.fromJson(Map<String, dynamic> json) {
    Menu menu = Menu(
      name: json["name"],
      items: json["items"],
    );

    for (var item in menu.items) {
      item.setParent(menu);
    }
    return menu;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "items": items,
      };
}

class Product extends MenuItem {
  final double price;

  Product({required super.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
      };
}
