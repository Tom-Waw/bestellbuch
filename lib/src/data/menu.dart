abstract class MenuItem {
  final String id;
  final String name;

  Menu? parent;

  MenuItem({required this.id, required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      json.containsKey("price") ? Product.fromJson(json) : Menu.fromJson(json);
}

class Menu extends MenuItem {
  final List<MenuItem> items;

  Menu({required super.id, required super.name, required this.items}) {
    for (MenuItem item in items) {
      item.parent = this;
    }
  }

  Menu? getRoot() {
    if (parent == null) return null;
    if (parent?.parent == null) return this;
    return parent?.getRoot();
  }

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        name: json["name"],
        items: json["items"].map(MenuItem.fromJson).cast<MenuItem>().toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "items": items,
      };
}

class Product extends MenuItem {
  final double price;

  Product({required super.id, required super.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };
}
