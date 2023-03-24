import 'table.dart';

class TablesService {
  Future<List<Table>> fetchData() async => Future.delayed(
        const Duration(seconds: 1),
        () => List.generate(6, (_) => Table()),
      );

  Future<void> add(Table t) async {}
  Future<void> delete(Table t) async {}
}
