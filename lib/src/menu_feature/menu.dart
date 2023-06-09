abstract class MenuItem {
  final String id;
  final String name;

  Menu? parent;

  MenuItem({required this.id, required this.name});

  String get path => parent == null ? id : "${parent!.path}/items/$id";

  factory MenuItem.fromJson(String id, Map<String, dynamic> json) =>
      json.containsKey("price")
          ? Product.fromJson(id, json)
          : Menu.fromJson(id, json);
}

class Menu extends MenuItem {
  final List<MenuItem> items;

  Menu({required super.id, required super.name, required this.items}) {
    for (MenuItem item in items) {
      item.parent = this;
    }
  }

  bool get isRoot => parent == null;
  Menu? get root => isRoot ? this : parent?.root;

  List<Product> get allProducts =>
      items.whereType<Product>().toList(growable: false) +
      items
          .whereType<Menu>()
          .expand((menu) => menu.allProducts)
          .toList(growable: false);

  factory Menu.fromJson(String id, Map<String, dynamic> json) => Menu(
        id: id,
        name: json["name"],
        items: json["items"] ?? [],
      );
}

class Product extends MenuItem {
  final double price;

  Product({required super.id, required super.name, required this.price});

  factory Product.fromJson(String id, Map<String, dynamic> json) => Product(
        id: id,
        name: json["name"],
        price: json["price"],
      );
}
