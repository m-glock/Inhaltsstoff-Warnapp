
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTables.dart';

class DbObject{

  int _id;
  // TODO: list for columns needed?

  // TODO: constructor needed?
  DbObject({int id}){
    this._id = id;
  }

  // Getter and Setter
  int get id => _id;

  // methods
  DbTables getTableType() {}
  Map<String, dynamic> toMap({bool withId: true}) {}

  // used when converting the row into an object
  // TODO: find out how to implement factory in abstract class
  static DbObject fromMap(Map<String, dynamic> data) {}
  //factory DbTable.fromMap(Map<String, dynamic> data) =>   new DbTable();
}