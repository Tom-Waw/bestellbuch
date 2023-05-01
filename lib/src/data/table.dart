import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  final int number;

  const Table({required this.number});

  String get name => "Tisch $number";

  factory Table.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) =>
      Table(number: snapshot.data()!['number']);

  Map<String, dynamic> toFirestore() {
    return {
      "number": number,
    };
  }
}
