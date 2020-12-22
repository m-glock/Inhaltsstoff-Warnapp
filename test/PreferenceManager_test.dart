import 'package:Inhaltsstoff_Warnapp/backend/Enums/PreferenceType.dart';
import 'package:Inhaltsstoff_Warnapp/backend/PreferenceManager.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Ingredient.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Product.dart';
import 'package:Inhaltsstoff_Warnapp/backend/database/databaseHelper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{

  final dbHelper = DatabaseHelper.instance;
  final db = await dbHelper.database;

//TODO implement
  test('create ingredient and change preference type', () async {
    var resultSetIngredient = await db.rawQuery('select name as ing_name from ingredient where name = "MilchTestIngredient"');
    var dbItem = resultSetIngredient.first;
    var ingrId = dbItem['ing_name'] as String;
    print(dbItem);

    //add test ingredient with preferenceType NotWanted
    dbHelper.add(Ingredient('MilchTestIngredient', PreferenceType.NotWanted, Ingredient.getCurrentDate()));
    //add map with ingredient with preferenceType to change
    Ingredient ingredient_milch = Ingredient("MilchTestIngredient", PreferenceType.NotPreferred, "null");
    Map<Ingredient, PreferenceType> preferenceToChange = {ingredient_milch:PreferenceType.Preferred};
    PreferenceManager.changePreference(preferenceToChange);

    //assert(scannedProduct != null);
  });


}