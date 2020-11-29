import 'package:Inhaltsstoff_Warnapp/database/tables/DbTable.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTableNames.dart';

import 'Type.dart';

class Ingredient extends DbTable{

  // Fields
  String _name;
  List<dynamic> _groups;

  // Constructor
  Ingredient(this._groups, this._name, {int id}) : super(id);

  // Getter and Setter
  String get name => _name;
  List<Type> get group => _groups;

  // Methods
  DbTableNames getTableType() { return DbTableNames.ingredient; }

  // TODO groups/group ids => how to handle joinTables or one to many relations both to and from database
  Map<String, dynamic> toMap({bool withId: true}){
    final map = new Map<String, dynamic>();
    map['name'] = _name;
    if(withId) map['id'] = super.id;
    //List<int> groupIds = new List();
    //_groups.forEach((element) => groupIds.add(element.id));
    //map['groups'] = groupIds;
    return map;
  }

  factory Ingredient.fromMap(Map<String, dynamic> data) => new Ingredient(
      data['groups'],
      data['name'],
      id: data['id']
  );

}