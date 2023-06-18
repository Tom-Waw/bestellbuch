import '../employees_feature/employee.dart';
import '../services/employee_service.dart';
import '../menu_feature/menu.dart';
import '../services/menu_service.dart';
import '../tables_feature/table.dart';
import '../services/table_service.dart';

class Order {
  final String id;
  Table table;
  Employee waiter;
  bool active;
  final Map<Product, int> items;

  Order({
    required this.id,
    required this.table,
    required this.waiter,
    this.active = true,
    items,
  }) : items = items ?? {};

  double get total => items.isNotEmpty
      ? items.entries
          .map((entry) => entry.key.price * entry.value)
          .reduce((value, element) => value + element)
      : 0;

  factory Order.fromJson(String id, Map<String, dynamic> json) => Order(
        id: id,
        table: TableService.to.allTables.firstWhere(
          (t) =>
              t.group.id == json["table"].split("@")[0] &&
              t.number == int.parse(json["table"].split("@")[1]),
        ),
        waiter: EmployeeService.to.employees.firstWhere(
          (e) => e.id == json["waiter"],
        ),
        active: json["active"],
        items: <Product, int>{
          for (var item in json["items"])
            MenuService.to.allProducts
                .firstWhere((p) => p.id == item["product"]): item["count"]
        },
      );

  Map<String, dynamic> toJson() => {
        "table": "${table.group.id}@${table.number}",
        "waiter": waiter.id,
        "active": active,
        "items": [
          for (var entry in items.entries)
            {
              "product": entry.key.id,
              "count": entry.value,
            }
        ],
      };
}
