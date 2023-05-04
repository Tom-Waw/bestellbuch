import 'menu.dart';
import 'table.dart';

class Order {
  final Table table;
  final Map<Product, int> items;

  Order({required this.table, this.items = const {}});

  double get total => items.entries
      .map((entry) => entry.key.price * entry.value)
      .reduce((value, element) => value + element);
}
