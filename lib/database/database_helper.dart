import 'dart:io';

import 'package:Inhaltsstoff_Warnapp/database/tables/DbObject.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/DbTables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// code adapted from https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
class DatabaseHelper {

  static final _databaseName = "MyDatabase9.db";
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
        onCreate: _onCreate);
  }

  // TODO how to insert all necessary tables with few lines?
  // TODO how to insert content of tables with few lines?
  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Ingredients (
            id INTEGER PRIMARY KEY,
            group_id INTEGER NOT NULL,
            name TEXT NOT NULL
          );
          ''');
    await db.execute('''
          CREATE TABLE Ingredient_Group (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          );
          ''');
  }

  Future<int> saveNewObjectToDb(DbObject object) async {
    Database db = await instance.database;
    Map<String, dynamic> row = object.toMap(withId: false);

    return await db.insert(object.getTableType().name, row);
  }

  Future<DbObject> getItemById(int id, DbTables tableType) async {
    Database db = await instance.database;
    List<Map> list = await db.query(tableType.name, where: 'id = ?', whereArgs: [id]);
    //List<Map> list = await db.rawQuery('SELECT * FROM Ingredient_Group WHERE id = ?', [id]);
    int length = list.length;
    return length > 0 ? tableType.fromMap(list[0]) : null;
  }

  Future<int> updateItem(DbObject object) async {
    Database db = await instance.database;
    return await db.update(object.getTableType().name, object.toMap(), where: 'id = ?', whereArgs: [object.id]);
  }

  Future<int> deleteItemById(int id, DbTables tableType) async {
    Database db = await instance.database;
    return await db.delete(tableType.name, where: 'id = ?', whereArgs: [id]);
  }
}