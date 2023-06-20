import '../services/order_service.dart';

class Employee {
  final String id;
  String name;

  Employee({required this.id, required this.name});

  bool get active => OrderService.to.activeOrders.any((o) => o.waiter == this);

  factory Employee.fromJson(String id, Map<String, dynamic> json) => Employee(
        id: id,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
