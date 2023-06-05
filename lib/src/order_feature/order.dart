import '../employees_feature/employee.dart';
import '../menu_feature/menu.dart';
import '../menu_feature/menu_controller.dart';
import '../tables_feature/table.dart';
import '../tables_feature/tables_controller.dart';

class Order {
  final String id;
  final Table table;
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
        table: TablesController.to.tables
            .firstWhere((t) => t.number == json["table"]),
        waiter: json["waiter"],
        active: json["active"],
        items: <Product, int>{
          for (var item in json["items"])
            MenuController.to.menus
                    .expand((menu) => menu.allProducts)
                    .firstWhere((product) => product.id == item["product"]):
                item["count"]
        },
      );

  Map<String, dynamic> toJson() => {
        "table": table.number,
        "waiter": waiter,
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
