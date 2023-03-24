import 'package:flutter/material.dart';

import 'catalog.dart';

class CatalogService {
  Future<Catalog> fetchData() async => Future.delayed(
        const Duration(seconds: 1),
        () => Catalog("main", [
          Catalog(
            "Getränke",
            [
              Product("Random Drink", 8.99),
              Catalog(
                "Alkoholische Getränke",
                [Product("Gin Tonic", 10.99), Product("Cuba Libre", 11.99)],
              ),
              Catalog(
                "Alkoholfreie Getränke",
                [Product("Wasser", 4.99)],
              ),
            ],
            icon: Icons.local_drink,
          ),
          Catalog("Speisen", [], icon: Icons.food_bank),
          Catalog(
            "Shishas",
            [Product("Artic Line", 7.99)],
            icon: Icons.smoking_rooms,
          ),
        ]),
      );

  Future<void> add(CatalogItem c) async {}
  Future<void> delete(CatalogItem c) async {}
}
