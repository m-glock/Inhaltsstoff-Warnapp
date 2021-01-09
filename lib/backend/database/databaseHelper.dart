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

  static final _databaseName = "MyDatabase15.db";
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

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    // load sql to create tables
    String fileTextCreate = await rootBundle.loadString('assets/database/create_tables_sql.txt');
    List<String> queriesCreate = fileTextCreate.split(';');
    queriesCreate.forEach((element) async {
      String query = element.replaceAll('\n', '').replaceAll('\r', '');
      if(element.isNotEmpty)
        await db.execute(query);
    });

    // load sql to insert the content into the DB that is static and does not changes during usage of the app
    String fileTextInsert = await rootBundle.loadString('assets/database/insert_into_tables_sql.txt');
    List<String> queriesInsert = fileTextInsert.split(';');
    queriesInsert.forEach((element) async {
      String query = element.replaceAll('\n', '').replaceAll('\r', '');
      if(element.isNotEmpty)
        await db.execute(query);
    });

    FoodApiAccess foodApi = FoodApiAccess.instance;

    // get allergens and vitamins from foodapi and save them into the DB
    List<String> allergens = await foodApi.getTranslatedValuesForTag('allergens');
    allergens.forEach((element) async {
      if(element.isNotEmpty)
        await db.execute(
            'INSERT INTO ingredient (preferenceTypeId, name, preferenceAddDate, typeId) VALUES (1, \'$element\', null, 1)');
    });

    List<String> vitamins = await foodApi.getTranslatedValuesForTag('vitamins');
    vitamins.forEach((element) async {
      if(element.isNotEmpty)
        await db.execute(
            'INSERT INTO ingredient (preferenceTypeId, name, preferenceAddDate, typeId) VALUES (2, \'$element\', null, 2)');
    });

    // special nutriments that are contained in ingredient list, but need to be handled separately
    List<String> nutriments = ['Calcium', 'Natrium', 'Kalium', 'Phosphor', 'Magnesium', 'Eisen', 'Jod', 'Fluorid', 'Zink', 'Selen'];
    List<String> ingredients = await foodApi.getTranslatedValuesForTag('ingredients');

    ingredients.forEach((element) async {
      if(element.isNotEmpty){
        element = element.replaceAll('\'', '\'\'');
        // ingredient is a nutriment, it will be inserted with the type id 2 for nutriment, otherwise with 3 for general
        int typeId = nutriments.contains(element) ? 2 : 3;
        await db.execute(
            'INSERT INTO ingredient (preferenceTypeId, name, preferenceAddDate, typeId) VALUES (1, \'$element\', null, $typeId)');
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

  // get a row with a specific id from a table
  //TODO check, if works? for example "await dbHelper.read(1, DbTableNames.ingredient);"
  Future<DbTable> read(int id, DbTableNames table) async {
    Database db = await instance.database;
    List<Map> list = await db.query(table.name, where: 'id = ?', whereArgs: [id]);
    int length = list.length;
    return length > 0 ? table.fromMap(list[0]) : null;
  }

  // read all rows with specific values
  // TODO: in progress
  Future<List <Map>> readAll(DbTableNames tableType) async {
    Database db = await instance.database;
    List<Map> list = await db.query(tableType.name);
    return list;
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