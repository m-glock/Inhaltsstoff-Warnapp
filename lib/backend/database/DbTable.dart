import 'DbTableNames.dart';

/*
* super class for every class that represents a database table
* all methods should be implemented by the subclasses
* */
abstract class DbTable{

  // Fields
  int id;

  // Constructor
  DbTable(int id) : id = id;

  // Methods
  DbTableNames getTableName();
  Map<String, dynamic> toMap({bool withId: true});
  static DbTable fromMap(Map<String, dynamic> data) {}
}