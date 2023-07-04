import '../employees_feature/employee.dart';
import '../menu_feature/menu.dart';
import '../services/employee_service.dart';
import '../services/menu_service.dart';
import '../services/table_service.dart';
import '../tables_feature/table.dart';

class Order {
  final String id;
  Table table;
  Employee waiter;
  final Map<Product, int> _items;
  final Map<Product, int> _payedItems = {};

  Order({
    required this.id,
    required this.table,
    required this.waiter,
    Map<Product, int>? items,
  }) : _items = items ?? {};

  Map<Product, int> get items => Map.unmodifiable(_items);

  double get total => _items.isNotEmpty
      ? _items.entries
          .map((entry) => entry.key.price * entry.value)
          .reduce((value, element) => value + element)
      : 0;

  void addItem(Product product) {
    _items.update(product, (count) => count + 1, ifAbsent: () => 1);
  }

  void addItems(Map<Product, int> items) {
    items.forEach((key, value) {
      _items.update(key, (count) => count + value, ifAbsent: () => value);
    });
  }

  void removeItem(Product product) {
    _items.update(product, (count) => count - 1);
    _items.removeWhere((key, value) => value <= 0);
  }

  void removeProduct(Product product) {
    _items.remove(product);
  }

  void removeItems(Map<Product, int> items) {
    items.forEach((key, value) {
      _items.update(key, (count) => count - value, ifAbsent: () => -1);
    });
    _items.removeWhere((key, value) => value <= 0);
  }

  void payItems(Map<Product, int> items) {
    items.forEach((key, value) {
      _items.update(key, (count) => count - value, ifAbsent: () => -1);
      _payedItems.update(key, (count) => count + value, ifAbsent: () => value);
    });
    _items.removeWhere((key, value) => value <= 0);
  }

  factory Order.fromJson(String id, Map<String, dynamic> json) => Order(
        id: id,
        table: TableService.to.allTables.firstWhere(
          (t) =>
              t.group.id == json["table"].split("@")[0] &&
              t.number == int.parse(json["table"].split("@")[1]),
        ),
        waiter: EmployeeService.to.allEmployees.firstWhere(
          (e) => e.id == json["waiter"],
        ),
        items: <Product, int>{
          for (var el in json["items"])
            MenuService.to.allProducts.firstWhere((p) => p.id == el["product"]):
                el["count"],
        },
      );

  Map<String, dynamic> toJson() => {
        "table": "${table.group.id}@${table.number}",
        "waiter": waiter.id,
        "items": [
          for (var entry in _items.entries)
            {
              "product": entry.key.id,
              "count": entry.value,
            }
        ],
        "payedItems": [
          for (var entry in _payedItems.entries)
            {
              "product": entry.key.id,
              "count": entry.value,
            }
        ],
      };

  Map<String, dynamic> toArchiveJson() {
    if (_items.isNotEmpty) throw Exception("Order is not payed yet");

    return {
      "table": "${table.group.id}@${table.number}",
      "waiter": {
        "id": waiter.id,
        ...waiter.toJson(),
      },
      "items": [
        for (var entry in _payedItems.entries)
          {
            "product": entry.key.id,
            ...entry.key.toJson(),
            "count": entry.value,
          }
      ],
    };
  }
}
