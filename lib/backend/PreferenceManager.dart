import 'dart:core';

import './database/DbTableNames.dart';
import 'Enums/ScanResult.dart';
import 'Ingredient.dart';
import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';

import 'Product.dart';
import 'database/DatabaseHelper.dart';

class PreferenceManager {

  /*
  * When the user changes the preference of one or multiple Ingredients, this method is called and
  * saves the information in the database
  * @param preferenceChanges: a map of ingredients and the preference types they should change to
  * */
  static void changePreference(
      Map<Ingredient, PreferenceType> preferenceChanges) async {
    final dbHelper = DatabaseHelper.instance;

    if (preferenceChanges?.isNotEmpty ?? true) {
      preferenceChanges.forEach((ingredient, preferenceType) async {
        ingredient.preferenceType  = preferenceType;
        //TODO only if preferencetype has changed
        if(preferenceType != PreferenceType.None) ingredient.preferenceAddDate = DateTime.now();
        await dbHelper.update(ingredient);
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
    List<Ingredient> ingredients = List();
    String tableName = DbTableNames.ingredient.name;

    if (preferenceTypes?.isEmpty ?? true) {
      List<Map<String, dynamic>> results = await dbHelper.customQuery('SELECT * FROM $tableName WHERE preferenceTypeId IS NOT \'None\'');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
      });
    }

    if (preferenceTypes != null && preferenceTypes.isNotEmpty) {
      List<String> preferenceTypeIds = preferenceTypes.map((preferenceType) => preferenceType.id.toString()).toList();
      String ids = preferenceTypeIds.reduce((value, element) => value + ', ' + element);

      List<Map<String, dynamic>> results = await dbHelper.customQuery('SELECT * FROM $tableName WHERE preferenceTypeId IN ($ids)');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
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
    List<Ingredient> ingredients = List();
    String tableName = DbTableNames.ingredient.name;

    if (type == null) {
      List<Map<String, dynamic>> results = await dbHelper.customQuery('SELECT * FROM $tableName');
      results.forEach((result) {
        ingredients.add(Ingredient.fromMap(result));
      });
    }

    if (type != null) {
      String typeId = type.id.toString();

      List<Map<String, dynamic>> results = await dbHelper.customQuery('SELECT * FROM $tableName WHERE typeId = $typeId LIMIT 100');
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
    product.itemizedScanResults = itemizedScanResults;

    return itemizedScanResults;
  }

  static Future<List<Ingredient>> getPreferredIngredientsIn(Product product) async {
    List<Ingredient> ingredients = product.ingredients;
    return (await getPreferencedIngredients([PreferenceType.Preferred]))
        .where((prefIngredient) => ingredients.contains(prefIngredient))
        .toList();
  }
}