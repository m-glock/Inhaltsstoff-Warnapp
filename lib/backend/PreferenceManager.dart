import 'dart:core';

import 'Ingredient.dart';
import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';

import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
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
  * get all Ingredients that are saved in the DB that do not have the preferenceType NONE
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
  * Get all Ingredients from the DB independent of their preference type
  * @param type: if only the ingredients of a specific type are relevant (i.e. vitamins, allergens)
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
  * get a list of all ingredient types (i.e. vitamin, allergen etc.)
  * @return: a list of all available types in the DB
  * */
  static List<Type> getIngredientsTypes() {
    //TODO implement
    List<Type> type;
    type.add(Type.Nutriment);
    type.add(Type.Allergen);
    type.add(Type.General);
    return type;
  }
}
