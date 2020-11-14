
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTables.dart';

class DbObject{

  int _id;

  // Getter and Setter
  int get id => _id;

  // methods
  DbTables getTableType() {}
  Map<String, dynamic> toMap({bool withId: true}) {}

  // used when converting the row into an object
  static DbObject fromMap(Map<String, dynamic> data) {}
}