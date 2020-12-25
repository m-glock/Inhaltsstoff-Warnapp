import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';
import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'package:intl/intl.dart';

import 'database/databaseHelper.dart';

class Ingredient extends DbTable {
  // Fields
  String _name;
  PreferenceType _preferencesType;
  String _preferenceAddDate;
  Type _type;

  static final columns = ["name", "preferenceTypeId", "preferenceAddDate", "typeId", "id"];

  // Constructor
  Ingredient(this._name, this._preferencesType, this._type, this._preferenceAddDate,
      {int id}) : super(id);

  // Getter and Setter
  String get name => _name;
  Type get type => _type;
  String get addDate => _preferenceAddDate;
  PreferenceType get preferenceType => _preferencesType;

  // Methods
  /*
  * get current date in a string format
  * from https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
  * @return: current date as a string in format yyyy-MM-dd-Hm
  * */
  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd-Hm');
    return formatter.format(now);
    //print(formatted); // something like 2013-04-20
  }


  // DB methods
  @override
  DbTableNames getTableName() {
    return DbTableNames.ingredient;
  }

  //TODO: handle foreign keys, -> actually ToDo?
  @override
  Map<String, dynamic> toMap({bool withId: true}) {
    final map = new Map<String, dynamic>();
    map['name'] = _name;
    map['preferenceType'] = _preferencesType;
    map['type'] = _type;
    map['preferenceAddDate'] = _preferenceAddDate;
    if (withId) map['id'] = super.id;
    return map;
  }

  static Ingredient fromMap(Map<String, dynamic> data) {
    return new Ingredient(data['name'], data['preferenceTypeId'], data['typeId'], data['preferenceAddDate'],
        id: data['id']);
  }
}
