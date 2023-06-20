import '../employees_feature/employee.dart';
import '../services/employee_service.dart';
import '../menu_feature/menu.dart';
import '../services/menu_service.dart';
import '../tables_feature/table.dart';
import '../services/table_service.dart';

class Order {
  final String id;
  String _tableId;
  String _waiterId;
  bool active;
  final Map<String, int> _items;

  Order({
    required this.id,
    required String tableId,
    required String waiterId,
    this.active = true,
    items,
  })  : _tableId = tableId,
        _waiterId = waiterId,
        _items = items ?? {};

  Table get table => TableService.to.allTables.firstWhere(
        (t) =>
            t.group.id == _tableId.split("@")[0] &&
            t.number == int.parse(_tableId.split("@")[1]),
      );

  Employee get waiter => EmployeeService.to.employees.firstWhere(
        (e) => e.id == _waiterId,
      );

  Map<Product, int> get items => _items.map(
        (key, value) => MapEntry(
          MenuService.to.allProducts.firstWhere(
            (p) => p.id == key,
          ),
          value,
        ),
      );

  double get total => items.isNotEmpty
      ? items.entries
          .map((entry) => entry.key.price * entry.value)
          .reduce((value, element) => value + element)
      : 0;

  factory Order.fromJson(String id, Map<String, dynamic> json) => Order(
        id: id,
        tableId: json["table"],
        waiterId: json["waiter"],
        active: json["active"],
        items: <String, int>{
          for (var entry in json["items"]) entry["product"]: entry["count"],
        },
      );

  Map<String, dynamic> toJson() => {
        "table": _tableId,
        "waiter": _waiterId,
        "active": active,
        "items": [
          for (var entry in _items.entries)
            {
              "product": entry.key,
              "count": entry.value,
            }
        ],
      };
}
