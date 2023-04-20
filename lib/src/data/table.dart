import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  final int? number;

  const Table({required this.number});

  String get name => "Tisch $number";

  factory Table.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Table(
      number: data?['number'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (number != null) "number": number,
    };
  }
}
