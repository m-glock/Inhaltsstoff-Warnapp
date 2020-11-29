import 'database/DbTable.dart';
import 'database/DbTableNames.dart';

class Type extends DbTable{

  // Fields
  String _name;

  // Constructor
  Type(this._name, {int id}) : super(id);

  // Getter and Setter
  String get name => _name;

  DbTableNames getTableName() { return DbTableNames.type; }

  // used when inserting a row in the table
  Map<String, dynamic> toMap({bool withId: true}){
    final map = new Map<String, dynamic>();
    map['name'] = _name;
    if(withId) map['id'] = super.id;
    return map;
  }

  // used when converting the row into an object
  factory Type.fromMap(Map<String, dynamic> data) => new Type(
      data['name'],
      id : data['id']
  );

}