import '../services/order_service.dart';

class TableGroup {
  final String id;
  String name;
  late final List<Table> tables;

  TableGroup({required this.id, required this.name, required size}) {
    tables = List<Table>.generate(
      size,
      (idx) => Table(group: this, number: idx + 1),
    );
  }

  factory TableGroup.fromJson(String id, Map<String, dynamic> json) =>
      TableGroup(
        id: id,
        name: json["name"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": tables.length,
      };
}

class Table {
  final TableGroup group;
  final int number;

  Table({required this.group, required this.number});

  String get name => "Tisch $number";

  bool get isAvailable => OrderService.to.orders.every((o) => o.table != this);
}
