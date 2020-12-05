import 'Type.dart';
import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Ingredient extends DbTable {
  // Fields
  int id;
  String name;
  int preferencesTypeId;
  String addDate;

  //TODO types?
  //List<dynamic> groups;

  static final columns = ["id", "name", "preferencesTypeId", "addDate"];

  // Constructor
  //Ingredient(this._groups, this._name, {int id}) : super(id);
  Ingredient(this.name, this.preferencesTypeId, this.addDate, {int id})
      : super(id);

  // Getter and Setter
  //String get name => _name;
  //List<Type> get group => _groups;

  // Methods
  DbTableNames getTableName() {
    return DbTableNames.ingredient;
  }

  // TODO groups/group ids => how to handle joinTables or one to many relations both to and from database
  Map<String, dynamic> toMap({bool withId: true}) {
    final map = new Map<String, dynamic>();
    map['name'] = name;
    map['preferencesTypeId'] = preferencesTypeId;
    map['addDate'] = addDate;
    if (withId) map['id'] = super.id;
    //List<int> groupIds = new List();
    //_groups.forEach((element) => groupIds.add(element.id));
    //map['groups'] = groupIds;
    return map;
  }

  /*static fromMap(Map map) {
    Ingredient ingredient = new Ingredient();
    ingredient.id = map["id"];
    ingredient.name = map["username"];
    ingredient.preferencesTypeId = map["preferencesTypeId"];
    ingredient.addDate = map["addDate"];

    return ingredient;
  }*/

  factory Ingredient.fromMap(Map<String, dynamic> data) =>
      new Ingredient(data['name'], data['preferencesTypeId'], data['addDate'],
          id: data['id']);

  //add dateNow to
  formatDate(addDate) {
    final DateTime now = DateTime.now();
    //https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
    final DateFormat formatter = DateFormat('yyyy-MM-dd-Hms');
    final String formatted = formatter.format(now);
    addDate = formatted;
    return addDate;
    //print(formatted); // something like 2013-04-20
  }

  //TODO implement
  changePreference(PreferenceType) {}
}
