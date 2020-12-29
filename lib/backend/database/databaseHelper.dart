import 'dart:io';

import 'package:Inhaltsstoff_Warnapp/backend/FoodApiAccess.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'DbTable.dart';
import 'DbTableNames.dart';

// code adapted from https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // comment in and execute once to delete old database, the comment out again
    // File(path).delete();
    return await openDatabase(path,
        version: _databaseVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate);
  }

  // set flag to use foreign keys
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // load sql to create tables and insert enum content
    await _executeQueriesFromFile(db, 'create_tables_sql');
    await _executeQueriesFromFile(db, 'insert_into_tables_sql');

    // get lists of ingredients from food api and save them into the DB
    await _insertIngredientsFromFoodApi(db, 'allergens', 1);
    await _insertIngredientsFromFoodApi(db, 'vitamins', 2);
    await _insertIngredientsFromFoodApi(db, 'minerals', 2);
    await _insertIngredientsFromFoodApi(db, 'ingredients', 3);
  }

  // execute sql queries that are saved in a text file in the assets folder
  Future<void> _executeQueriesFromFile(Database db, String filename) async {
    String fileText = await rootBundle.loadString('assets/database/$filename.txt');
    List<String> queries = fileText.split(';');
    queries.forEach((element) async {
      String query = element.replaceAll('\n', '').replaceAll('\r', '');
      if(element.isNotEmpty)
        await db.execute(query);
    });
  }

  // insert ingredients that are saved in the food api under a certain tag
  // (such as vitamins) into the DB
  Future<void> _insertIngredientsFromFoodApi(Database db, String tag, int typeId) async {
    List<String> ingredients = await FoodApiAccess.instance.getTranslatedValuesForTag(tag);
    ingredients.forEach((element) async {
      if(element.isNotEmpty){
        try{
          element = element.replaceAll('\'', '\'\'');
          await db.execute(
              'INSERT INTO ingredient (preferenceTypeId, name, preferenceAddDate, typeId) VALUES (1, \'$element\', null, $typeId)');
        } catch(exception) {
          // some ingredients have already been added as allergens or vitamins
          // ingredients should not have duplicates in the DB, so we make sure
          // not to insert ingredients that are already in the DB
          DatabaseException ex = exception as DatabaseException;
          if(!ex.isUniqueConstraintError())
            print('Database Error when inserting the ingredients into the database.');
        }
      }
    });
  }

  // insert one row into a table
  Future<int> add(DbTable object) async {
    Database db = await instance.database;
    Map<String, dynamic> row = object.toMap(withId: false);

    return await db.insert(object.getTableName().name, row);
  }

  // insert multiple rows into one or more tables
  Future<List<int>> addAll(List<DbTable> objects) async {
    Database db = await instance.database;
    List<int> newRowIds = new List();

    objects.forEach((element) async {
      Map<String, dynamic> row = element.toMap(withId: false);
      int rowId = await db.insert(element.getTableName().name, row);
      newRowIds.add(rowId);
    });

    return newRowIds;
  }

  // get a row with a specific value from a table (id is the default column)
  Future<DbTable> read(DbTableNames tableType, List<dynamic> whereargs, {String whereColumn = 'id'}) async {
    Database db = await instance.database;
    if(whereargs.length != 1)
      throw Exception('Wrong number of arguments. If you want to get more than one element, please use the readAll method.');

    List<Map> list = await db.query(tableType.name, where: '$whereColumn = ?', whereArgs: whereargs);
    DbTable tableObject = await tableType.fromMap(list[0]);
    return list.length > 0 ? tableObject : null;
  }

  // read all rows with specific values
  Future<List<DbTable>> readAll(DbTableNames tableType, {String whereColumn, List<dynamic> whereArgs}) async {
    Database db = await instance.database;
    if(whereArgs != null && whereArgs.length != 1)
      throw Exception('Wrong number of arguments.');

    List<Map> list;
    if(whereColumn == null)
      list = await db.query(tableType.name);
    else
      list = await db.query(tableType.name, where: '$whereColumn = ?', whereArgs: whereArgs);

    List<DbTable> objectList = new List();
    list.forEach((element) async {
      objectList.add(await tableType.fromMap(element));
    });
    return objectList;
  }

  // update a specific row in a table
  Future<int> update(DbTable object) async {
    Database db = await instance.database;
    return await db.update(object.getTableName().name, object.toMap(), where: 'id = ?', whereArgs: [object.id]);
  }

  // update multiple rows in a table
  Future<List<int>> updateAll(List<DbTable> objects) async {
    Database db = await instance.database;
    List<int> updatedRowIds = new List();

    objects.forEach((element) async {
      int rowId = await db.update(element.getTableName().name, element.toMap(), where: 'id = ?', whereArgs: [element.id]);
      updatedRowIds.add(rowId);
    });

    return updatedRowIds;
  }

  // delete one row with a specific id
  Future<int> delete(DbTable object) async {
    Database db = await instance.database;
    return await db.delete(object.getTableName().name, where: 'id = ?', whereArgs: [object.id]);
  }

  // delete multiple rows
  Future<List<int>> deleteAll(List<DbTable> objects) async {
    Database db = await instance.database;
    List<int> deletedRowIds = new List();

    objects.forEach((element) async {
      int rowId = await db.delete(element.getTableName().name, where: 'id = ?', whereArgs: [element.id]);
      deletedRowIds.add(rowId);
    });

    return deletedRowIds;
  }
}