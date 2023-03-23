import 'package:flutter/material.dart';

abstract class CatalogItem {
  static int count = 0;

  late final int id;
  Catalog? _parent;
  final String name;

  CatalogItem(this.name) {
    id = count++;
  }

  Catalog get parent => _parent!;
  void setParent(Catalog parent) {
    _parent = parent;
  }
}

class Catalog extends CatalogItem {
  final IconData? icon;
  final List<CatalogItem> items;

  Catalog(super.name, this.items, {this.icon}) {
    for (CatalogItem item in items) {
      item._parent = this;
    }
  }
}

class Product extends CatalogItem {
  final double price;

  Product(super.name, this.price);
}
