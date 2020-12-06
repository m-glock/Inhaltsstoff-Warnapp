import 'dart:core';

import 'Ingredient.dart';
import 'PreferenceType.dart';
import 'Type.dart';

import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'database/databaseHelper.dart';

class PreferenceManager {
  final dbHelper = DatabaseHelper.instance;

  /*
  * change the preference of one ingredient
  * @param ingredient: the ingredient where the preference type should change
  * @param preferenceType: the preferenceType to change to
  * */
  static void changePreference(Ingredient ingredient, PreferenceType preferenceType) {
    // TODO implement
  }

  /*
  * returns all Ingredients that have a preferenceType that is not NONE
  * @param preferenceTypes: if only ingredients with a specific preference type are requested
  * @return: a list of all ingredients that the user has preferenced
  * */
  static List<Ingredient> getPreferencedIngredients({List<PreferenceType> preferenceTypes}) {
    //TODO implement
    List<Ingredient> ingredients = List();
    ingredients.add(Ingredient('Zucker', PreferenceType.Unwanted, ''));
    ingredients.add(Ingredient('Milch', PreferenceType.Unwanted, ''));
    ingredients.add(Ingredient('Magnesium', PreferenceType.NotPreferred, ''));
    ingredients.add(Ingredient('Wasser', PreferenceType.Preferred, ''));
    //await dbHelper.readAll(DbTableNames.ingredient);
    return ingredients;
  }

  /*
  * @param type: if only the ingredients of a specific type are relevant
  * @return: all Ingredients that are available in the database
  * */
  static List<Ingredient> getAllAvailableIngredients({Type type}) {
    //TODO implement
    List<Ingredient> ingredients = List();
    ingredients.add(Ingredient('Zucker', PreferenceType.None, ''));
    ingredients.add(Ingredient('Milch', PreferenceType.Unwanted, ''));
    ingredients.add(Ingredient('Magnesium', PreferenceType.None, ''));
    ingredients.add(Ingredient('Wasser', PreferenceType.Preferred, ''));
    return ingredients;
  }

  /*
  * @return: a list of all available types in the DB
  * */
  static List<Type> getIngredientsTypes() {
    //TODO implement
    List<Type> type;
    type.add(Type('Vitamin'));
    type.add(Type('Allergen'));
    type.add(Type('Nutriment'));
    return type;
  }
}
