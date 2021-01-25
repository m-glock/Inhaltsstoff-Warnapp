/*
* super class for every class that represents a database table
* all methods should be implemented by the subclasses
* */
abstract class DbTable extends Comparable {
  int id;

  DbTable(int id) : id = id;

  String getTableName();

  Future<Map<String, dynamic>> toMap({bool withId: true});

  static DbTable fromMap(Map<String, dynamic> data) {}

  @override
  int compareTo(other) {
    DbTable one = other as DbTable;
    DbTable two = this;
    return one.id.compareTo(two.id);
  }
}
