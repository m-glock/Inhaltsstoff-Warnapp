import 'dart:core';

import 'package:Inhaltsstoff_Warnapp/backend/Ingredient.dart';
import 'package:Inhaltsstoff_Warnapp/backend/PreferenceType.dart';

import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'database/databaseHelper.dart';

class PreferenceManager {
  final dbHelper = DatabaseHelper.instance;

  static changePreference(Ingredient, PreferenceType) {}

  static getPreferencedIngredients() async {
    List<Ingredient> ingredients;
    await dbHelper.readAll(DbTableNames.ingredient);

  }

  // TODO define
/*getPreferencedIngredients(PreferenceType){
}*/

  //TODO what does it mean under available
  static getAvailableIngredients() {
    List<Ingredient> ingredients;
  }

  //TODO available?
  static getAvailableIngredientsOfType(Type) {
    List<Ingredient> ingredients;
  }
  
  static getIngredientsTypes() {
    List<Type> type;
  }
}
