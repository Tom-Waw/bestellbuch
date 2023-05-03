import 'menu.dart';
import 'order.dart';
import 'table.dart';

class Store {
  final List<Menu> menus;
  final List<Table> tables;
  final Map<Table, Order> orders = {};

  Store({required this.menus, required this.tables});
}
