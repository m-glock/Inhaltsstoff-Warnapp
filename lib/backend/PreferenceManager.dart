import 'dart:core';

import './database/DatabaseHelper.dart';
import './databaseEntities/Ingredient.dart';
import './databaseEntities/Product.dart';
import './enums/DbTableNames.dart';
import './enums/PreferenceType.dart';
import './enums/ScanResult.dart';
import './enums/Type.dart';

class PreferenceManager {
  /*
  * Save new/changed preferences of the user in the database.
  * @param preferenceChanges: a map of ingredients
  *                           and the preference types they should change to
  * */
  static void changePreference(
      Map<Ingredient, PreferenceType> preferenceChanges) async {
    final dbHelper = DatabaseHelper.instance;

    if (preferenceChanges?.isNotEmpty ?? true) {
      preferenceChanges.forEach((ingredient, preferenceType) async {
        ingredient.preferenceType = preferenceType;
        if (preferenceType != PreferenceType.None)
          ingredient.preferenceAddDate = DateTime.now();
        await dbHelper.update(ingredient);
      });
    }
  }

  /*
  * Get all preferenced ingredients from the database
  * or just ones with specific preferenceTypes.
  * @param preferenceTypes: specific preferenceTypes for filtering
  * @return: a list of all matching ingredients that the user has preferred
  * */
  static Future<List<Ingredient>> getPreferencedIngredients(
      [List<PreferenceType> preferenceTypes]) async {
    final dbHelper = DatabaseHelper.instance;
    List<Ingredient> ingredients = List();
    String tableName = DbTableNames.ingredient.name;

    if (preferenceTypes?.isEmpty ?? true) {
      // get all ingredients that have a preferenceType other than NONE
      int prefTypeId = PreferenceType.None.id;
      List<Map<String, dynamic>> results = await dbHelper.customQuery(
          'SELECT * FROM $tableName WHERE preferenceTypeId IS NOT $prefTypeId');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
      });
    } else {
      // filter for one or more specific preferenceType
      List<String> preferenceTypeIds = preferenceTypes
          .map((preferenceType) => preferenceType.id.toString())
          .toList();
      String ids =
          preferenceTypeIds.reduce((value, element) => value + ', ' + element);

      List<Map<String, dynamic>> results = await dbHelper.customQuery(
          'SELECT * FROM $tableName WHERE preferenceTypeId IN ($ids)');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
      });
    }

    return ingredients;
  }

  /*
  * Get all Ingredients from the DB or ones with a specific type.
  * @param type: specific types for filtering
  * @return: a list of all matching ingredients that match
  * */
  static Future<List<Ingredient>> getAllAvailableIngredients(
      [Type type]) async {
    final dbHelper = DatabaseHelper.instance;
    List<Ingredient> ingredients = List();
    String tableName = DbTableNames.ingredient.name;

    if (type == null) {
      // get all ingredients from the database
      List<Map<String, dynamic>> results =
          await dbHelper.customQuery('SELECT * FROM $tableName');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
      });
    }

    if (type != null) {
      //get only the ingredients of the specified type from the database
      String typeId = type.id.toString();
      List<Map<String, dynamic>> results = await dbHelper
          .customQuery('SELECT * FROM $tableName WHERE typeId = $typeId');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
      });
    }

    return ingredients;
  }

  /*
  * Get all preferred ingredients and assign them a ScanResult on whether they are in the product or not.
  * Red = Ingredient is not wanted, but is contained in the product
  * Yellow = Ingredient is not preferred, but is contained in the product
  * Green = Ingredient is either not preferred or not wanted
  *         but is not contained in the product
  * @param product: the product whose ingredients should be compared to the preferred ingredients
  * @return: a Map for each preferred Ingredient and its respective ScanResult for the product
  * */
  static Future<Map<Ingredient, ScanResult>> getItemizedScanResults(
      Product product) async {
    Map<Ingredient, ScanResult> itemizedScanResults = Map();
    List<Ingredient> productIngredients = product.ingredients;

    // get all ingredients the user has preferenced
    List<PreferenceType> options = [
      PreferenceType.NotWanted,
      PreferenceType.NotPreferred
    ];
    List<Ingredient> preferredIngredients =
        await getPreferencedIngredients(options);

    // determine the itemized scan results and the overall scan result
    // by checking for each preferred ingredient whether it is in the product
    ScanResult overallResult = ScanResult.Green;
    preferredIngredients.forEach((ingredient) {
      ScanResult result;

      // check if there is an ingredient in the product whose name is similar
      // to the preferred ingredient
      List<Ingredient> matchingIngredients = productIngredients
          .where((i) =>
              i.name.toLowerCase().contains(ingredient.name.toLowerCase()))
          .toList();
      if (matchingIngredients.isNotEmpty) {
        result = ingredient.preferenceType == PreferenceType.NotWanted
            ? ScanResult.Red
            : ScanResult.Yellow;

        if (overallResult != ScanResult.Red) overallResult = result;
      } else {
        result = ScanResult.Green;
      }
      itemizedScanResults[ingredient] = result;
    });

    // set the overall scan result of the product
    product.setScanResult(overallResult);

    return itemizedScanResults;
  }

  /*
  * Find all preferenced ingredients in a product.
  * @param product: the product to check the ingredients of
  * @return a list of all preferenced in a product
  * */
  static Future<List<Ingredient>> getPreferredIngredientsIn(
      Product product) async {
    List<Ingredient> ingredients = product.ingredients;
    return (await getPreferencedIngredients([PreferenceType.Preferred]))
        .where((prefIngredient) => ingredients.contains(prefIngredient))
        .toList();
  }
}
