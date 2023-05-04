class Table {
  String id;
  final int number;

  Table({required this.id, required this.number});

  String get name => "Table $number";

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json["id"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
      };
}
