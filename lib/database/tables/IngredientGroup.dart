
import 'package:Inhaltsstoff_Warnapp/database/tables/DbObject.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTables.dart';

class IngredientGroup implements DbObject{

  int _id;
  String _name;

  // Constructor
  IngredientGroup(this._name, {int id}) : _id = id;

  // Getter and Setter
  @override
  int get id => _id;

  String get name => _name;

  @override
  DbTables getTableType() { return DbTables.ingredientGroup; }

  // used when inserting a row in the table
  Map<String, dynamic> toMap({bool withId: true}){
    final map = new Map<String, dynamic>();
    map['name'] = _name;
    if(withId) map['id'] = _id;
    return map;
  }

  // used when converting the row into an object
  factory IngredientGroup.fromMap(Map<String, dynamic> data) =>   new IngredientGroup(
      data['name'],
      id : data['id']
  );

}