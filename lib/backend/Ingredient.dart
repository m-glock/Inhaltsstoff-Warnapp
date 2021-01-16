import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';
import 'database/DbTable.dart';
import 'database/DbTableNames.dart';

class Ingredient extends DbTable {

  // Fields
  String _name;
  PreferenceType preferenceType;
  DateTime preferenceAddDate;
  Type _type;

  // Getter and Setter
  String get name => _name;
  Type get type => _type;

  // Constructor
  Ingredient(this._name, this.preferenceType, this._type, this.preferenceAddDate,
      {int id}) : super(id);

  // Methods

  // DB methods
  @override
  DbTableNames getTableName() {
    return DbTableNames.ingredient;
  }

  @override
  Map<String, dynamic> toMap({bool withId: true}) {
    final map = new Map<String, dynamic>();
    map['name'] = _name;
    map['preferenceTypeId'] = preferenceType.id;
    map['typeId'] = _type.id;
    String test = preferenceAddDate?.toIso8601String();
    map['preferenceAddDate'] = test;
    if (withId) map['id'] = super.id;
    return map;
  }

  static Ingredient fromMap(Map<String, dynamic> data) {
    int prefTypeId = data['preferenceTypeId'];
    PreferenceType prefType = PreferenceType.values.elementAt(prefTypeId - 1);

    int typeId = data['typeId'];
    Type type = Type.values.elementAt(typeId - 1);

    DateTime preferenceAddDate = data['preferenceAddDate'] != null ? DateTime.parse(data['preferenceAddDate']) : null;
    return new Ingredient(data['name'], prefType, type, preferenceAddDate,
        id: data['id']);
  }

  bool operator ==(Object other) {
    return identical(this, other) ||
            other is Ingredient &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}