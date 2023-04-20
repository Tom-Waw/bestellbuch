import 'menu.dart';
import 'order.dart';
import 'table.dart';

class Store {
  final List<Table> tables;
  final Menu menu;
  final Map<Table, Order> orders = {};

  Store(this.tables, this.menu);
}
