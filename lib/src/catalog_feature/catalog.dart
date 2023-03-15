import 'package:flutter/material.dart';

abstract class CatalogItem {
  final int id;
  Catalog? _parent;
  final String name;

  CatalogItem(this.id, this.name);

  Catalog get parent => _parent!;
  void setParent(Catalog parent) {
    _parent = parent;
  }
}

class Catalog extends CatalogItem {
  final IconData icon;
  final List<CatalogItem> items;

  Catalog(super.id, super.name, this.icon, this.items) {
    for (CatalogItem item in items) {
      item._parent = this;
    }
  }
}

class Product extends CatalogItem {
  final double cost;

  Product(super.id, super.name, this.cost);
}
