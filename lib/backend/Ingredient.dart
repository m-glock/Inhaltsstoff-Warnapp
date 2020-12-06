import 'PreferenceType.dart';
import 'Type.dart';
import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'package:intl/intl.dart';

class Ingredient extends DbTable {
  // Fields
  String _name;
  PreferenceType _preferencesType;
  String _addDate;
  List<Type> _types;

  static final columns = ["id", "name", "preferencesTypeId", "addDate"];

  // Constructor
  Ingredient(this._name, this._preferencesType, this._addDate, {int id})
      : super(id);

  // Getter and Setter
  String get name => _name;
  List<Type> get types => _types;
  String get addDate => _addDate;
  PreferenceType get preferenceType => _preferencesType;

  // Methods
  DbTableNames getTableName() {
    return DbTableNames.ingredient;
  }

  Map<String, dynamic> toMap({bool withId: true}) {
    final map = new Map<String, dynamic>();
    map['name'] = name;
    //map['preferencesTypeId'] = preferencesTypeId;
    map['addDate'] = addDate;
    if (withId) map['id'] = super.id;
    //List<int> groupIds = new List();
    //_groups.forEach((element) => groupIds.add(element.id));
    //map['groups'] = groupIds;
    return map;
  }

  static fromMap(Map<String, dynamic> data) =>
      new Ingredient(data['name'], data['preferencesTypeId'], data['addDate'],
          id: data['id']);

  /*
  * get current date in a string format
  * from https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
  * @return: current date as a string in format yyyy-MM-dd-Hm
  * */
  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd-Hm');
    return formatter.format(now);
    //print(formatted); // something like 2013-04-20
  }

  /*
  * changes the preference type of this ingredient
  * @param preferenceType: the new preference for this ingredient
  * */
  void changePreference(PreferenceType preferenceType) {
    //TODO implement

  }
}
