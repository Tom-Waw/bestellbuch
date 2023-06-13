import '../employees_feature/employee.dart';
import '../employees_feature/employee_service.dart';
import '../menu_feature/menu.dart';
import '../menu_feature/menu_service.dart';
import '../tables_feature/table.dart';
import '../tables_feature/table_service.dart';

class Order {
  final String id;
  Table table;
  final Employee waiter;
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
        table: TableService.to.tables.firstWhere(
          (t) => t.number == json["table"],
        ),
        waiter: EmployeeService.to.employees.firstWhere(
          (e) => e.id == json["waiter"],
        ),
        active: json["active"],
        items: <Product, int>{
          for (var item in json["items"])
            MenuService.to.menus
                    .expand((menu) => menu.allProducts)
                    .firstWhere((product) => product.id == item["product"]):
                item["count"]
        },
      );

  Map<String, dynamic> toJson() => {
        "table": table.number,
        "waiter": waiter.id,
        "active": active,
        "items": [
          for (var entry in items.entries)
            {
              "count": entry.value,
              "product": entry.key.id,
            }
        ],
      };
}
