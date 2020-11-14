import 'package:Inhaltsstoff_Warnapp/database/tables/DbTable.dart';

import 'IngredientGroup.dart';

class Ingredient extends DbTable{

  // TODO: one ingredient can belong to more than one group
  IngredientGroup _group;
  String _name;

  Ingredient(id, this._group, this._name) : super(id);

  // used when inserting a row in the table
  @override
  Map<String, dynamic> toMap({bool withId: true}){
    final map = new Map<String, dynamic>();
    map["group_id"] = _group.id;
    map["name"] = _name;
    if(withId) map["id"] = super.id;
    return map;
  }

  // used when converting the row into an object
  factory Ingredient.fromMap(Map<String, dynamic> data) =>   new Ingredient(
      data['group_id'],
      data['name'],
      data['id']
  );

  // Getter and Setter
  IngredientGroup get group => _group;
  int get groupId => _group.id;
  set group(IngredientGroup newGroup) => _group = newGroup;

  String get name => _name;

}