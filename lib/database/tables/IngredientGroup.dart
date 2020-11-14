
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTable.dart';

class IngredientGroup extends DbTable{

  String _name;

  // Constructor
  IngredientGroup(id, this._name) : super(id);

  // Getter and Setter
  String get name => _name;

  // used when inserting a row in the table
  Map<String, dynamic> toMap({bool withId: true}){
    final map = new Map<String, dynamic>();
    map["name"] = _name;
    if(withId) map["id"] = super.id;
    return map;
  }

  // used when converting the row into an object
  factory IngredientGroup.fromMap(Map<String, dynamic> data) =>   new IngredientGroup(
      data['id'],
      data['name']
  );
}