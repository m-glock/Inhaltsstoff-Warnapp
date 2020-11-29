import 'dart:io';

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
    return await openDatabase(path,
        version: _databaseVersion,
        //onConfigure: _onConfigure,
        onCreate: _onCreate);
  }

  /*static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }*/

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    String fileText = await rootBundle.loadString('assets/create_tables_sql.txt');
    List<String> queries = fileText.split(';');
    queries.forEach((element) async {
      await db.execute(element);
    });
  }

  // insert one row into a table
  Future<int> add(DbTable object) async {
    Database db = await instance.database;
    Map<String, dynamic> row = object.toMap(withId: false);

    return await db.insert(object.getTableType().name, row);
  }

  // insert multiple rows into one or more tables
  Future<List<int>> addAll(List<DbTable> objects) async {
    Database db = await instance.database;
    List<int> newRowIds = new List();

    objects.forEach((element) async {
      Map<String, dynamic> row = element.toMap(withId: false);
      int rowId = await db.insert(element.getTableType().name, row);
      newRowIds.add(rowId);
    });

    return newRowIds;
  }

  // get a row with a specific id from a table
  Future<DbTable> read(int id, DbTableNames table) async {
    Database db = await instance.database;
    List<Map> list = await db.query(table.name, where: 'id = ?', whereArgs: [id]);
    int length = list.length;
    return length > 0 ? table.fromMap(list[0]) : null;
  }

  // read all rows with specific values
  // TODO: in progress
  /*Future<DbTable> readAll(List<String> arguments, DbTables) async {
    Database db = await instance.database;
    List<Map> list = await db.query(tableType.name, where: 'id = ?', whereArgs: [id]);
    int length = list.length;
    return length > 0 ? tableType.fromMap(list[0]) : null;
  }*/

  // update a specific row in a table
  Future<int> update(DbTable object) async {
    Database db = await instance.database;
    return await db.update(object.getTableType().name, object.toMap(), where: 'id = ?', whereArgs: [object.id]);
  }

  // update multiple rows in a table
  Future<List<int>> updateAll(List<DbTable> objects) async {
    Database db = await instance.database;
    List<int> updatedRowIds = new List();

    objects.forEach((element) async {
      int rowId = await db.update(element.getTableType().name, element.toMap(), where: 'id = ?', whereArgs: [element.id]);
      updatedRowIds.add(rowId);
    });

    return updatedRowIds;
  }

  // delete one row with a specific id
  Future<int> delete(DbTable object) async {
    Database db = await instance.database;
    return await db.delete(object.getTableType().name, where: 'id = ?', whereArgs: [object.id]);
  }

  // delete multiple rows
  Future<List<int>> deleteAll(List<DbTable> objects) async {
    Database db = await instance.database;
    List<int> deletedRowIds = new List();

    objects.forEach((element) async {
      int rowId = await db.delete(element.getTableType().name, where: 'id = ?', whereArgs: [element.id]);
      deletedRowIds.add(rowId);
    });

    return deletedRowIds;
  }
}