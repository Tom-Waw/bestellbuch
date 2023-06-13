class TableGroup {
  final String id;
  final String name;
  late final List<Table> tables;

  TableGroup({required this.id, required this.name, required number})
      : tables = List<Table>.generate(
          number,
          (index) => Table(number: index + 1),
        );

  factory TableGroup.fromJson(String id, Map<String, dynamic> json) =>
      TableGroup(
        id: id,
        name: json["name"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": tables.length,
      };
}

class Table {
  final int number;

  Table({required this.number});

  String get name => "Tisch $number";
}
