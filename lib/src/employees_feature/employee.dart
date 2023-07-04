class EmployeeGroup {
  final String id;
  String name;
  List<Employee> employees;
  Set<String> menuNotifiers;

  EmployeeGroup({
    required this.id,
    required this.name,
    List<Employee>? employees,
    List<String>? menuNotifiers,
  })  : employees = employees ?? [],
        menuNotifiers = Set.from(menuNotifiers ?? []);

  factory EmployeeGroup.fromJson(String id, Map<String, dynamic> json) =>
      EmployeeGroup(
        id: id,
        name: json["name"],
        menuNotifiers: List.from(json["menuNotifiers"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "menuNotifiers": menuNotifiers.toList(),
      };
}

class Employee {
  final String id;
  final EmployeeGroup group;
  String name;

  Employee({required this.id, required this.group, required this.name});

  factory Employee.fromJson(
    String id,
    EmployeeGroup group,
    Map<String, dynamic> json,
  ) =>
      Employee(
        id: id,
        group: group,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
