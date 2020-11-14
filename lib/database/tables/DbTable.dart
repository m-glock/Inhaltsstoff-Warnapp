
abstract class DbTable{

  final int _id;
  String _tableName;
  // TODO: list for columns needed?

  // TODO: no id in constructor, because DB should auto increment -> optional parameter?
  DbTable(this._id);

  // Getter and Setter
  int get id => _id;
  String get tableName => _tableName;

  // methods
  Map<String, dynamic> toMap({bool withId: true}){
  }

  // used when converting the row into an object
  // TODO: find out how to implement factory in abstract class
  //factory DbTable.fromMap(Map<String, dynamic> data) =>   new DbTable();
}