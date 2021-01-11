import 'dart:core';

import 'Enums/ScanResult.dart';
import 'Ingredient.dart';
import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';

import 'Product.dart';
import 'database/databaseHelper.dart';

class PreferenceManager {
  /*
  * When the user changes the preference of one or multiple Ingredients, this method is called and
  * saves the information in the database
  * @param preferenceChanges: a map of ingredients and the preference types they should change to
  * */
  static void changePreference(
      Map<Ingredient, PreferenceType> preferenceChanges) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;

    if (preferenceChanges?.isNotEmpty ?? true) {
      preferenceChanges.forEach((ingredient, preferenceType) async {
        //retrieve preferencetypeid and ingredient_id from the db
        List<Map> resultSetIngredient = await db.rawQuery(
            'select i.preferencetypeid as pr_id, i.id as ing_id from ingredient i join preferencetype p where i.name = ? and i.preferencetypeid=p.id',
            [ingredient.name]);

        Map<dynamic, dynamic> dbItem = resultSetIngredient.first;
        int ingrId = dbItem['ing_id'];

        //retrieve id from the new preferenceType
        List<Map> resultSetPreferenceType = await db.rawQuery(
            'select id as pr_id from preferencetype where name = ?',
            [preferenceType.name]);

        Map<dynamic, dynamic> dbItem_1 = resultSetPreferenceType.first;
        int preferenceTypeIdNew = dbItem_1['pr_id'];

        // update preferencetypeid in ingredient
        await db.rawUpdate(
            'UPDATE Ingredient SET preferencetypeid = ?, preferenceAddDate = ? WHERE id = ?',
            [preferenceTypeIdNew, Ingredient.getCurrentDate(), ingrId]);

        //setter for the ingredient
        ingredient.preferenceType  = preferenceType;
      });
    }
  }
  /*
  * get all Ingredients that are saved in the DB that have a preferenceType other than NONE
  * @param preferenceTypes: if only ingredients with a specific preference type are requested
  * @return: a list of all ingredients that the user has preferred
  * */
  static Future<List<Ingredient>> getPreferencedIngredients(
      [List<PreferenceType> preferenceTypes]) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    List<Ingredient> ingredients = new List();

    if (preferenceTypes?.isEmpty ?? true) {
      List<Map> results = await db.rawQuery(
          'select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where p.name is not \'None\'');
      results.forEach((result) {
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });
    }

    if (preferenceTypes?.isNotEmpty ?? true) {
      preferenceTypes.forEach((element) async {
        String elementName = element.name;

        List<Map> results = await db.rawQuery(
            'select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where p.name = \'$elementName\'');
        results.forEach((result) {
          Ingredient ingredient = Ingredient.fromMap(result);
          ingredients.add(ingredient);
        });
      });
    }

    return ingredients;
  }

  /*
  * Get all Ingredients from the DB independent of whether they have a set preference type or not
  * @param type: if only the ingredients of a specific type are relevant (i.e. vitamins, allergens)
  * @return: all Ingredients that are available in the database
  * */
  static Future<List<Ingredient>> getAllAvailableIngredients([Type type]) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    List<Ingredient> ingredients = new List();

    if (type == null) {
      List<Map> results = await db.rawQuery(
          'select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id limit 100');
      results.forEach((result) {
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });
    }

    if (type != null) {
      String elementName = type.name;
      List<Map> results = await db.rawQuery(
          'select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where t.name = \'$elementName\' limit 100');
      results.forEach((result) {
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });

    }

    return ingredients;
  }

  /*
  * Get all preferred ingredients and assign them a ScanResult on whether they are in the product or not.
  * Red = Ingredient is not wanted, but is contained in the product
  * Yellow = Ingredient is not preferred, but is contained in the product
  * Green = Ingredient is preferred or none and is contained in the product, or there is no match in the database
  *
  * @param product: the product whose ingredient should be compared to the preferred ingredients
  * @return: a Map for each preferred Ingredient and its respective ScanResult to the product
  * */
  static Future<Map<Ingredient, ScanResult>> getItemizedScanResults(
      Product product) async {
    Map<Ingredient, ScanResult> itemizedScanResults = Map();
    List<PreferenceType> options = [PreferenceType.NotWanted, PreferenceType.NotPreferred];
    List<Ingredient> preferredIngredients = await getPreferencedIngredients(options);
    List<Ingredient> productIngredients = product.ingredients;

    ScanResult overallResult = ScanResult.Green;
    preferredIngredients.forEach((ingredient) {
      ScanResult result;
      if(productIngredients.contains(ingredient)){
        result = ingredient.preferenceType == PreferenceType.NotWanted
            ? ScanResult.Red
            : ScanResult.Yellow;

        if(overallResult != ScanResult.Red) overallResult = result;
      } else {
        result = ScanResult.Green;
      }
      itemizedScanResults[ingredient] = result;
    });

    product.scanResult = overallResult;

    return itemizedScanResults;
  }
}