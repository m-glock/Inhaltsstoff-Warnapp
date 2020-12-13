import 'dart:core';

import 'Enums/ScanResult.dart';
import 'Ingredient.dart';
import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';

import 'Product.dart';
import 'database/databaseHelper.dart';

class PreferenceManager {
  final dbHelper = DatabaseHelper.instance;

  /*
  * When the user changes the preference of one or multiple Ingredients, this method is called and
  * saves the information in the database
  * @param preferenceChanges: a map of ingredients and the preference types they should change to
  * */
  static void changePreference(Map<Ingredient, PreferenceType> preferenceChanges) {
    // TODO implement
  }

  /*
  * get all Ingredients that are saved in the DB that have a preferenceType other than NONE
  * @param preferenceTypes: if only ingredients with a specific preference type are requested
  * @return: a list of all ingredients that the user has preferenced
  * */
  static List<Ingredient> getPreferencedIngredients({List<PreferenceType> preferenceTypes}) {
    //TODO implement
    List<Ingredient> ingredients = List();
    ingredients.add(Ingredient('Zucker', PreferenceType.NotWanted, ''));
    ingredients.add(Ingredient('Milch', PreferenceType.NotWanted, ''));
    ingredients.add(Ingredient('Magnesium', PreferenceType.NotPreferred, ''));
    ingredients.add(Ingredient('Wasser', PreferenceType.Preferred, ''));
    //await dbHelper.readAll(DbTableNames.ingredient);
    return ingredients;
  }

  /*
  * Get all Ingredients from the DB independent of whether they have a set preference type or not
  * @param type: if only the ingredients of a specific type are relevant (i.e. vitamins, allergens)
  * @return: all Ingredients that are available in the database
  * */
  static List<Ingredient> getAllAvailableIngredients({Type type}) {
    //TODO implement
    List<Ingredient> ingredients = List();
    ingredients.add(Ingredient('Zucker', PreferenceType.NotWanted, ''));
    ingredients.add(Ingredient('Milch', PreferenceType.NotWanted, ''));
    ingredients.add(Ingredient('Schokolade', PreferenceType.NotPreferred, ''));
    ingredients.add(Ingredient('Magnesium', PreferenceType.NotPreferred, ''));
    ingredients.add(Ingredient('Wasser', PreferenceType.Preferred, ''));
    ingredients.add(Ingredient('Vitamin C', PreferenceType.None, ''));
    return ingredients;
  }

  /*
  * Get all preferred ingredients and assign them a ScanResult on whether they are in the product or not.
  * Red = Ingredient is not wanted, but is contained in the product
  * Yellow = Ingredient is not preferred, but is contained in the product
  * Green = Ingredient is neither preferred or wanted, but is not contained in the product
  *
  * @param product: the product whose ingredient should be compared to the preferred ingredients
  * @return: a Map for each preferred Ingredient and its respective ScanResult to the product
  * */
  static Map<Ingredient, ScanResult> getItemizedScanResults(Product product) {
    Map<Ingredient, ScanResult> itemizedScanResults = Map();

    itemizedScanResults[Ingredient('Zucker', PreferenceType.NotWanted, '')] = ScanResult.Red; //not wanted and in product
    itemizedScanResults[Ingredient('Schokolade', PreferenceType.NotPreferred, '')] = ScanResult.Yellow; // not preferred and in product
    itemizedScanResults[Ingredient('Magnesium', PreferenceType.NotPreferred, '')] = ScanResult.Green; //not preferred and not in product
    //itemizedScanResults[Ingredient('Wasser', PreferenceType.Preferred, '')] = ScanResult.Red; //preferred and not in product

    return itemizedScanResults;
  }
}