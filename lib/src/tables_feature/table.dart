class TableGroup {
  final String id;
  late final List<Table> tables;

  TableGroup({required this.id, required number}) {
    tables = List<Table>.generate(number, (index) => Table(number: index));
  }

  factory TableGroup.fromJson(String id, Map<String, dynamic> json) =>
      TableGroup(
        id: id,
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": tables.length,
      };
}

class Table {
  final int number;

  Table({required this.number});

  String get name => "Tisch $number";
}
