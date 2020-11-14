import 'package:Inhaltsstoff_Warnapp/database/tables/DbObject.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTables.dart';

import 'IngredientGroup.dart';

class Ingredient implements DbObject{

  // TODO: one ingredient can belong to more than one group
  String _name;
  IngredientGroup _group;

  Ingredient(this._group, this._name, {int id});

  // Getter and Setter
  @override
  int get id => id;

  String get name => _name;

  IngredientGroup get group => _group;
  int get groupId => _group.id;
  set group(IngredientGroup newGroup) => _group = newGroup;

  @override
  DbTables getTableType() { return DbTables.ingredients; }

  // used when inserting a row in the table
  @override
  Map<String, dynamic> toMap({bool withId: true}){
    final map = new Map<String, dynamic>();
    map['group_id'] = _group.id;
    map['name'] = _name;
    if(withId) map['id'] = id;
    return map;
  }

  // used when converting the row into an object
  factory Ingredient.fromMap(Map<String, dynamic> data) =>   new Ingredient(
      data['group_id'],
      data['name'],
      id: data['id']
  );

}