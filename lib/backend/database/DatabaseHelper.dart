import 'package:Essbar/backend/database/DatabaseContainer.dart';
import 'package:sqflite/sqflite.dart';
import 'DbTable.dart';
import 'DbTableNames.dart';

// code adapted from https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
class DatabaseHelper {

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // insert one row into a table
  Future<int> add(DbTable object, {DbTableNames to, Map<String, dynamic> values}) async {
    Database db = await DatabaseContainer.instance.database;
    
    if(to != null && values != null){
      return await db.insert(to.name, values);
    } else {
      Map<String, dynamic> row = await object.toMap(withId: false);
      return await db.insert(object.getTableName().name, row);
    }
  }

  // insert multiple rows into one or more tables
  Future<List<int>> addAll(List<DbTable> objects) async {
    Database db = await DatabaseContainer.instance.database;
    List<int> newRowIds = new List();

    objects.forEach((element) async {
      Map<String, dynamic> row = await element.toMap(withId: false);
      int rowId = await db.insert(element.getTableName().name, row);
      newRowIds.add(rowId);
    });

    return newRowIds;
  }

  // get a row with a specific value from a table (id is the default column)
  Future<DbTable> read(DbTableNames tableType, List<dynamic> whereArgs, {String whereColumn = 'id'}) async {
    Database db = await DatabaseContainer.instance.database;
    if(whereArgs.length != 1)
      throw Exception('Wrong number of arguments. If you want to get more than one element, please use the readAll method.');

    List<Map> list = await db.query(tableType.name, where: '$whereColumn = ?', whereArgs: whereArgs);
    return list.length > 0 ? await tableType.fromMap(list[0]) : null;
  }

  // read all rows with specific values
  Future<List<DbTable>> readAll(DbTableNames tableType, {String whereColumn, List<dynamic> whereArgs}) async {
    Database db = await DatabaseContainer.instance.database;
    if(whereArgs != null && whereArgs.length != 1)
      throw Exception('Wrong number of arguments.');

    List<Map<String, dynamic>> list;
    if(whereColumn == null)
      list = await db.query(tableType.name);
    else
      list = await db.query(tableType.name, where: '$whereColumn = ?', whereArgs: whereArgs);


    if(tableType == DbTableNames.productIngredient || tableType == DbTableNames.productList){
      return await _getElementsFromJoinTable(list, whereColumn, tableType);
    } else {
      List<DbTable> objectList = new List();
      for(Map<String, dynamic> element in list){
        objectList.add(await tableType.fromMap(element));
      }
      return objectList;
    }
  }

  Future<List<DbTable>> _getElementsFromJoinTable(List<Map<String, dynamic>> list, String whereColumn, DbTableNames joinTableType) async {
    List<DbTable> objectList = new List();
    String columnToQuery;
    DbTableNames tableName;

    // check whether the ingredients or the products are queried from the join table
    if(whereColumn == 'productId'){
      bool getIngredient = joinTableType == DbTableNames.productIngredient;
      columnToQuery = getIngredient ? 'ingredientId' : 'listId';
      tableName = getIngredient ? DbTableNames.ingredient : DbTableNames.list;
    } else {
      columnToQuery = 'productId';
      tableName = DbTableNames.product;
    }

    // get ingredient/product object for each row in join table
    for(Map<String, dynamic> element in list){
      int objectId = element[columnToQuery];
      DbTable object = await read(tableName, [objectId]);
      objectList.add(object);
    }

    return objectList;
  }

  // update a specific row in a table
  Future<int> update(DbTable object) async {
    Database db = await DatabaseContainer.instance.database;
    Map<String, dynamic> objectRows = await object.toMap();
    return await db.update(object.getTableName().name, objectRows, where: 'id = ?', whereArgs: [object.id]);
  }

  // update multiple rows in a table
  Future<List<int>> updateAll(List<DbTable> objects) async {
    Database db = await DatabaseContainer.instance.database;
    List<int> updatedRowIds = new List();

    objects.forEach((element) async {
      Map<String, dynamic> objectRows = await element.toMap();
      int rowId = await db.update(element.getTableName().name, objectRows, where: 'id = ?', whereArgs: [element.id]);
      updatedRowIds.add(rowId);
    });

    return updatedRowIds;
  }

  // delete one row
  Future<int> delete(DbTable object) async {
    Database db = await DatabaseContainer.instance.database;
    return await db.delete(object.getTableName().name, where: 'id = ?', whereArgs: [object.id]);
  }

  // delete multiple rows
  Future<List<int>> deleteAll(List<DbTable> objects) async {
    Database db = await DatabaseContainer.instance.database;
    List<int> deletedRowIds = new List();

    objects.forEach((element) async {
      int rowId = await db.delete(element.getTableName().name, where: 'id = ?', whereArgs: [element.id]);
      deletedRowIds.add(rowId);
    });

    return deletedRowIds;
  }

  Future<List<Map<String, dynamic>>> customQuery(String query) async {
    Database db = await DatabaseContainer.instance.database;
    return await db.rawQuery(query);
  }
}