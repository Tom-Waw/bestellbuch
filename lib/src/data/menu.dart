import 'package:flutter/material.dart';

abstract class MenuItem {
  static int count = 0;

  late final int id;
  Menu? _parent;
  final String name;

  MenuItem(this.name) {
    id = count++;
  }

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
}

class Product extends MenuItem {
  final double price;

  Product(super.name, this.price);
}
