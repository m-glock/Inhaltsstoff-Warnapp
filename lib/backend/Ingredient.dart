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

  /*
   * changes the preference type of this ingredient
   * @param preferenceType: the new preference for this ingredient
   * */
  void changePreference(PreferenceType preferenceType)  {
    this._preferencesType = preferenceType;
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
    map['preferenceType'] = _preferencesType.id;
    map['type'] = _type.id;
    map['preferenceAddDate'] = _preferenceAddDate;
    if (withId) map['id'] = super.id;
    return map;
  }



  static Ingredient fromMap(Map<String, dynamic> data) {
    int prefTypeId = data['preferenceTypeId'];
    PreferenceType prefType = PreferenceType.values.elementAt(prefTypeId - 1);

    int typeId = data['typeId'];
    Type type = Type.values.elementAt(typeId - 1);

    return new Ingredient(data['name'], prefType, type, data['preferenceAddDate'],
        id: data['id']);
  }
}