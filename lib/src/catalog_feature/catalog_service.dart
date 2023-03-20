import 'package:flutter/material.dart';

import 'catalog.dart';

class CatalogService {
  Future<Catalog> fetchData() async => Future.delayed(
        const Duration(seconds: 1),
        () => Catalog(1, "main", Icons.check, [
          Catalog(2, "Getränke", Icons.local_drink, [
            Product(1, "Random Drink", 8.99),
            Catalog(4, "Alkoholische Getränke", Icons.medication, [
              Product(2, "Gin Tonic", 10.99),
              Product(3, "Cuba Libre", 11.99),
            ]),
            Catalog(5, "Alkoholfreie Getränke", Icons.medication, [
              Product(4, "Wasser", 4.99),
            ]),
          ]),
          Catalog(3, "Speisen", Icons.food_bank, []),
          Catalog(4, "Shishas", Icons.smoking_rooms, [
            Product(5, "Artic Line", 7.99),
          ]),
        ]),
      );

  Future<void> add(CatalogItem item) async {}
  Future<void> delete(CatalogItem item) async {}
}
