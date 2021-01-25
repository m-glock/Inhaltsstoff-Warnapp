import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../FoodApiAccess.dart';
import '../Enums/Type.dart';

class DatabaseContainer{

  static final String _databaseName = "FoodDatabase.db";
  static final int _databaseVersion = 1;
  static Database _database;

  // lazily instantiate the db the first time it is accessed
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // make this a Singleton class
  DatabaseContainer._privateConstructor();
  static final DatabaseContainer instance = DatabaseContainer._privateConstructor();

  /*
  * Open the database or creates it if it doesn't exist.
  * @return the Database object
  * */
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate);
  }

  /*
  * Set flag to use foreign keys.
  * @param db: the Database object referencing to the current database
  * */
  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /*
  * Execute SQL queries to create and fill the database tables on creation of the database.
  * @param db: the Database object referencing to the current database
  * @param version: the current version of the database
  * */
  Future<void> _onCreate(Database db, int version) async {
    // load sql to create tables and insert enum content
    await _executeQueriesFromFile(db, 'create_tables_sql.txt');
    await _executeQueriesFromFile(db, 'insert_into_tables_sql.txt');

    // get lists of ingredients from food api and save them in the DB
    await _insertIngredientsFromFoodApi(db, 'allergens', Type.Allergen.id);
    await _insertIngredientsFromFoodApi(db, 'vitamins', Type.Nutriment.id);
    await _insertIngredientsFromFoodApi(db, 'minerals', Type.Nutriment.id);
    await _insertIngredientsFromFoodApi(db, 'ingredients', Type.General.id);
  }

  /*
  * Execute SQL queries that are saved in a text file in the assets folder.
  * @param db: the Database object referencing to the current database
  * @param fileName: name of file with SQL queries to execute (including extension)
  * */
  Future<void> _executeQueriesFromFile(Database db, String fileName) async {
    // read file from asset folder
    String fileText = await rootBundle.loadString('assets/database/$fileName');

    // parse to separate SQL queries and execute each one
    List<String> queries = fileText.split(';');
    queries.forEach((element) async {
      String query = element.replaceAll('\n', '').replaceAll('\r', '');
      if(element.isNotEmpty)
        await db.execute(query);
    });
  }

  /*
  * Insert ingredients that are saved in the food api under a certain tag
  * (such as vitamins) into the DB.
  * @param db: the Database object referencing to the current database
  * @param tag: tag name for the food API taxonomy (i.e. allergen)
  * @param typeId: id of the type the accessed ingredient should have
  * */
  Future<void> _insertIngredientsFromFoodApi(Database db, String tag, int typeId) async {
    // get translated ingredientNames from the Food API
    List<String> ingredientNames = await FoodApiAccess.instance.translationManager.getTranslatedValuesForTag(tag);
    ingredientNames.forEach((name) async {
      if(name.isNotEmpty){
        try{
          name = name.replaceAll('\'', '\'\'');
          await db.execute(
              'INSERT INTO ingredient (preferenceTypeId, name, preferenceAddDate, typeId) VALUES (1, \'$name\', null, $typeId)');
        } catch(exception) {
          // some ingredients have already been added as allergens or vitamins
          // and should not be added as a general ingredient again
          DatabaseException ex = exception as DatabaseException;
          if(!ex.isUniqueConstraintError())
            print('Database Error when inserting the ingredients into the database.');
        }
      }
    });
  }
}