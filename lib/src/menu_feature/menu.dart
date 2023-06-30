import '../shared/utils.dart';

abstract class MenuItem with Compare<MenuItem> {
  final String id;
  String name;

  Menu? parent;

  MenuItem({required this.id, required this.parent, required this.name});

  factory MenuItem.fromJson(
    String id,
    Menu? parent,
    Map<String, dynamic> json,
  ) =>
      json.containsKey("price")
          ? Product.fromJson(id, parent, json)
          : Menu.fromJson(id, parent, json);

  Map<String, dynamic> toJson();

  @override
  int compareTo(MenuItem other) {
    if (other is Product && this is Menu) return -1;
    if (other is Menu && this is Product) return 1;
    return name.compareTo(other.name);
  }
}

class Menu extends MenuItem {
  late final List<MenuItem> items;

  Menu({
    required super.id,
    required super.parent,
    required super.name,
    List<MenuItem>? items,
  }) : items = items ?? [];

  bool get isRoot => parent == null;
  Menu get root => isRoot ? this : parent!.root;

  List<Product> get allProducts =>
      items.whereType<Product>().toList() +
      items.whereType<Menu>().expand((menu) => menu.allProducts).toList();

  List<Menu> get allMenus =>
      items.whereType<Menu>().toList() +
      items.whereType<Menu>().expand((menu) => menu.allMenus).toList();

  factory Menu.fromJson(
    String id,
    Menu? parent,
    Map<String, dynamic> json,
  ) =>
      Menu(
        id: id,
        parent: parent,
        name: json["name"],
        items: json["items"] ?? [],
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "parent": parent?.id,
      };
}

class Product extends MenuItem {
  double price;

  Product({
    required super.id,
    required super.parent,
    required super.name,
    required this.price,
  });

  factory Product.fromJson(
    String id,
    Menu? parent,
    Map<String, dynamic> json,
  ) =>
      Product(
        id: id,
        parent: parent,
        name: json["name"],
        price: json["price"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "parent": parent?.id,
        "price": price,
      };
}
