class Employee {
  final String id;
  String name;
  bool active;

  Employee({required this.id, required this.name, this.active = false});

  factory Employee.fromJson(String id, Map<String, dynamic> json) => Employee(
        id: id,
        name: json["name"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "active": active,
      };
}
