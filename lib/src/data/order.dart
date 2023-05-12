import '../management/state_service.dart';
import 'menu.dart';
import 'table.dart';

class Order {
  final String id;
  final Table table;
  bool active;
  final Map<Product, int> items;

  Order({required this.id, required this.table, this.active = true, items})
      : items = items ?? {};

  double get total => items.isNotEmpty
      ? items.entries
          .map((entry) => entry.key.price * entry.value)
          .reduce((value, element) => value + element)
      : 0;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        table: StateService.to.tables.firstWhere((t) => t.id == json["table"]),
        active: json["active"],
        items: <Product, int>{
          for (var item in json["items"])
            StateService.to.menus
                    .expand((menu) => menu.allProducts)
                    .firstWhere((product) => product.id == item["product"]):
                item["count"]
        },
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "table": table.id,
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
