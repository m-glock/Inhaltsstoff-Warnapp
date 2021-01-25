import '../enums/DbTableNames.dart';
import '../enums/PreferenceType.dart';
import '../enums/Type.dart';
import './superClasses/DbTable.dart';

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


  // compare two ingredients on the basis of their id
  bool operator ==(Object other) {
    return identical(this, other) ||
            other is Ingredient &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  // methods from super class
  @override
  String getTableName() {
    return DbTableNames.ingredient.name;
  }

  @override
  Future<Map<String, dynamic>> toMap({bool withId: true}) async {
    final map = new Map<String, dynamic>();
    String convertedDate = preferenceAddDate?.toIso8601String();

    map['name'] = _name;
    map['preferenceTypeId'] = preferenceType.id;
    map['typeId'] = _type.id;
    map['preferenceAddDate'] = convertedDate;
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
}