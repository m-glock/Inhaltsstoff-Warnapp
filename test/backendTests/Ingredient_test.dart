import 'package:Essbar/backend/Enums/PreferenceType.dart';
import 'package:Essbar/backend/Ingredient.dart';
import 'package:Essbar/backend/Enums/Type.dart';
import 'package:Essbar/main.dart';



import '../../lib/backend/PreferenceManager.dart';
import '../../lib/backend/database/DatabaseHelper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import '../../lib/main.dart' as app;
import '../../lib/main.dart';
//import 'package:test/test.dart';

void main() {

  Ingredient ingredient = new Ingredient("name", PreferenceType.None, Type.General, null);

  //app.main();
  test('test toMap() ingredient', () {
    var ingredient1 = ingredient.name;
    assert(ingredient1 != null);
  });
}

  /*
  //TODO implement
  test('create ingredient and change preference type', () async {
    //var resultSetIngredient = await db.rawQuery('select name as ing_name from ingredient where name = "MilchTestIngredient"');
    //var dbItem = resultSetIngredient.first;
    //var ingrId = dbItem['ing_name'] as String;
    //print(dbItem);

    //add test ingredient with preferenceType NotWanted

    //dbHelper.add(Ingredient('MilchTestIngredient', PreferenceType.NotWanted, Ingredient.getCurrentDate()));
    //add map with ingredient with preferenceType to change
    //Ingredient ingredient_milch = Ingredient("MilchTestIngredient", PreferenceType.NotPreferred, "null");
    Ingredient ingredient_milch = Ingredient("Hydroxocobalamin",
        PreferenceType.NotPreferred, Type.Nutriment, DateTime.parse(''));
    Map<Ingredient, PreferenceType> preferenceToChange = {
      ingredient_milch: PreferenceType.Preferred
    };
    PreferenceManager.changePreference(preferenceToChange);
    Map<Ingredient, PreferenceType> preferenceToChange1 = {
      ingredient_milch: PreferenceType.NotPreferred
    };
    PreferenceManager.changePreference(preferenceToChange1);

    //assert(scannedProduct != null);
  });

  //TODO check
  test('get ingredients due to the preference type NotWanted', () async {
    List<PreferenceType> preferenceTypes = List<PreferenceType>();
    preferenceTypes.add(PreferenceType.NotWanted);
    List <Ingredient> ingredients =
        await PreferenceManager.getPreferencedIngredients(preferenceTypes);
    assert(ingredients != null);
  });

  //TODO check
  test('get ingredients due to the preference type None', () async {
    List <Ingredient> ingredients = await PreferenceManager.getPreferencedIngredients();
    assert(ingredients != null);
  });

  //TODO check
  test('get all available ingredients without a type', () async {
    List <Ingredient> ingredients = await PreferenceManager.getAllAvailableIngredients();
    assert(ingredients != null);
  });

  //TODO check
  test('get all available ingredients with a specific type', () async {
    List <Ingredient> ingredients = await
        PreferenceManager.getAllAvailableIngredients(Type.General);
    assert(ingredients != null);
  });

  //TODO check
  test('get itemized scan results: red', () async {
    //var ingredients = //PreferenceManager.getItemizedScanResults(Product(_name, _imageUrl, _barcode, _scanDate));
    //assert(ingredients != null);
  });

  // TODO implement tests for PreferenceManager.getItemizedScanResults()
*/