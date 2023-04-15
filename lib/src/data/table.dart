class Table {
  static int count = 1;

  late final int id;
  late final String name;

  Table() {
    id = count++;
    name = "Tisch $id";
  }
}
