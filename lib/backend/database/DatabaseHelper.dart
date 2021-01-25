import 'DatabaseContainer.dart';
import 'package:sqflite/sqflite.dart';
import 'DbTable.dart';
import 'DbTableNames.dart';

// code adapted from https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
class DatabaseHelper {

  // make this a Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  /*
  * Insert one row into a table.
  * @param object: an object representing a database entity to be inserted
  * @param to: name of the database table the object should be inserted into
  *            if it differs from the object type (i.e. a join table)
  * @param values: row values to be inserted into the table
  * @return the id of the inserted row
  * */
  Future<int> add(DbTable object, [DbTableNames to, Map<String, dynamic> values]) async {
    Database db = await DatabaseContainer.instance.database;

    // if to and value are given, insert into specified other table
    // else insert into table of object
    if(to != null && values != null){
      return await db.insert(to.name, values);
    } else {
      values = await object.toMap(withId: false);
      return await db.insert(object.getTableName().name, values);
    }
  }

  /*
  * Insert multiple rows into one or more tables.
  * @param objects: list of objects representing a database entity to be inserted
  * @return a list of ids of the inserted rows
  * */
  Future<List<int>> addAll(List<DbTable> objects) async {
    Database db = await DatabaseContainer.instance.database;
    List<int> newRowIds = new List();

    // insert each element into the db
    objects.forEach((element) async {
      Map<String, dynamic> row = await element.toMap(withId: false);
      int rowId = await db.insert(element.getTableName().name, row);
      newRowIds.add(rowId);
    });

    return newRowIds;
  }

  /*
  * Select one row with from a table with a where clause.
  * @param tableName: name of the table to select from
  * @param whereArgs: list of arguments for a where clause
  * @param whereColumn: name of the column for the where clause
  * @return the database object
  * */
  Future<DbTable> read(DbTableNames tableName, List<dynamic> whereArgs, {String whereColumn = 'id'}) async {
    Database db = await DatabaseContainer.instance.database;
    if(whereArgs.length != 1)
      throw Exception('Wrong number of arguments. If you want to get more than one element, please use the readAll method.');

    // check of at least one element was found and return the first one
    List<Map<String, dynamic>> list = await db.query(tableName.name, where: '$whereColumn = ?', whereArgs: whereArgs);
    return list.length > 0 ? await tableName.fromMap(list[0]) : null;
  }

  /*
  * Select all rows from a table, optionally with a where clause.
  * @param tableName: name of the table to select from
  * @param whereColumn: name of the column for the where clause
  * @param whereArgs: list of arguments for a where clause
  * @return a list of database objects
  * */
  Future<List<DbTable>> readAll(DbTableNames tableName, [String whereColumn, List<dynamic> whereArgs]) async {
    Database db = await DatabaseContainer.instance.database;
    if(whereArgs != null && whereArgs.length != 1)
      throw Exception('Wrong number of arguments.');

    // if no where clause is defined get all elements from the table
    // else only get the matching ones
    List<Map<String, dynamic>> rowsFromDb;
    if(whereColumn == null)
      rowsFromDb = await db.query(tableName.name);
    else
      rowsFromDb = await db.query(tableName.name, where: '$whereColumn = ?', whereArgs: whereArgs);

    // handle if the table to select from is a join table
    if(tableName == DbTableNames.productIngredient || tableName == DbTableNames.productList)
      return await _fromJoinTable(rowsFromDb, whereColumn, tableName);

    List<DbTable> objectList = new List();
    for(Map<String, dynamic> row in rowsFromDb){
      objectList.add(await tableName.fromMap(row));
    }
    return objectList;
  }

  /*
  * Create objects from elements from a join table.
  * @param rowsFromDb: the rows from the first table of the join
  * @param whereColumn: name of the column for the where clause
  * @param joinTableName: name of the join table
  * @return a list of database objects
  * */
  Future<List<DbTable>> _fromJoinTable(List<Map<String, dynamic>> rowsFromDb, String whereColumn, DbTableNames joinTableName) async {
    List<DbTable> objectList = new List();
    String columnToQuery;
    DbTableNames tableName;

    // check whether the products or the ingredients/lists are queried from the join table
    if(whereColumn == 'productId'){
      bool queryOnIngredient = joinTableName == DbTableNames.productIngredient;
      columnToQuery = queryOnIngredient ? 'ingredientId' : 'listId';
      tableName = queryOnIngredient ? DbTableNames.ingredient : DbTableNames.list;
    } else {
      columnToQuery = 'productId';
      tableName = DbTableNames.product;
    }

    // get corresponding object for each row in join table
    for(Map<String, dynamic> element in rowsFromDb){
      int objectId = element[columnToQuery];
      DbTable object = await read(tableName, [objectId]);
      objectList.add(object);
    }

    return objectList;
  }

  /*
  * Update a specific row in a table.
  * @param object: the database object to update
  * @return the id of the updated row
  * */
  Future<int> update(DbTable object) async {
    Database db = await DatabaseContainer.instance.database;
    Map<String, dynamic> objectRows = await object.toMap();
    return await db.update(object.getTableName().name, objectRows, where: 'id = ?', whereArgs: [object.id]);
  }

  /*
  * Update multiple rows in a table.
  * @param objects: list of the database objects to update
  * @return a list of ids of the updated rows
  * */
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

  /*
  * Delete a row in a table.
  * @param object: the database object to delete
  * @return the id of the deleted row
  * */
  Future<int> delete(DbTable object) async {
    Database db = await DatabaseContainer.instance.database;
    return await db.delete(object.getTableName().name, where: 'id = ?', whereArgs: [object.id]);
  }

  /*
  * Delete multiple rows in a table.
  * @param objects: list of the database objects to delete
  * @return a list of ids of the deleted rows
  * */
  Future<List<int>> deleteAll(List<DbTable> objects) async {
    Database db = await DatabaseContainer.instance.database;
    List<int> deletedRowIds = new List();

    objects.forEach((element) async {
      int rowId = await db.delete(element.getTableName().name, where: 'id = ?', whereArgs: [element.id]);
      deletedRowIds.add(rowId);
    });

    return deletedRowIds;
  }

  /*
  * Execute a custom query that cannot be done with the existing CRUD methods
  * @param query: the query to execute
  * @return a list of all rows (as Maps) returned for the query
  * */
  Future<List<Map<String, dynamic>>> customQuery(String query) async {
    Database db = await DatabaseContainer.instance.database;
    return await db.rawQuery(query);
  }
}