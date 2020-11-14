import 'dart:io';

import 'package:Inhaltsstoff_Warnapp/database/tables/IngredientGroup.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> create(IngredientGroup ingredientGroup) async {
    Database db = await instance.database;
    IngredientGroup newGroup = IngredientGroup(1, 'vegan');
    Map<String, dynamic> row = newGroup.toMap(withId: true);

    return await db.insert('Ingredient_Group', row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<IngredientGroup> getItemById(int id) async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM Ingredient_Group WHERE id = ?', [id]);
    return list.length > 0 ? IngredientGroup.fromMap(list[0]) : null;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateItem(IngredientGroup group) async {
    Database db = await instance.database;
    return await db.update('Ingredient_Group', group.toMap(), where: 'id = ?', whereArgs: [group.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteById(int id) async {
    Database db = await instance.database;
    return await db.delete('Ingredient_Group', where: 'id = ?', whereArgs: [id]);
  }
}