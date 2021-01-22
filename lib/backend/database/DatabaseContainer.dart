
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../FoodApiAccess.dart';

class DatabaseContainer{

  static final _databaseName = "FoodDatabase.db";
  static final _databaseVersion = 1;
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // make this a singleton class
  DatabaseContainer._privateConstructor();
  static final DatabaseContainer instance = DatabaseContainer._privateConstructor();

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // comment in and execute once to delete old database, the comment out again
    //deleteDatabase(path);
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
    List<String> ingredients = await FoodApiAccess.instance.translationManager.getTranslatedValuesForTag(tag);
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
}