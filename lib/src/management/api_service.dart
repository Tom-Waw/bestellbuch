import 'package:flutter/material.dart' hide Table;

import '../data/menu.dart';
import '../data/store.dart';
import '../data/table.dart';

class APIService {
  Future<Store> fetchData() async => Future.delayed(
      const Duration(seconds: 1),
      () => Store(
            Menu("main", [
              Menu(
                "Getränke",
                [
                  Product("Random Drink", 8.99),
                  Menu(
                    "Alkoholische Getränke",
                    [Product("Gin Tonic", 10.99), Product("Cuba Libre", 11.99)],
                  ),
                  Menu(
                    "Alkoholfreie Getränke",
                    [Product("Wasser", 4.99)],
                  ),
                ],
                icon: Icons.local_drink,
              ),
              Menu("Speisen", [], icon: Icons.food_bank),
              Menu(
                "Shishas",
                [Product("Artic Line", 7.99)],
                icon: Icons.smoking_rooms,
              ),
            ]),
            List.generate(6, (_) => Table()),
          ));

  Future<void> add(dynamic o) async {}
  Future<void> delete(dynamic o) async {}
}
