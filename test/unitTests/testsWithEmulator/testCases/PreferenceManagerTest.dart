import 'package:Essbar/backend/PreferenceManager.dart';
import 'package:Essbar/backend/databaseEntities/Product.dart';
import 'package:Essbar/backend/enums/DbTableNames.dart';
import 'package:Essbar/backend/database/DatabaseHelper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Essbar/backend/Enums/PreferenceType.dart';
import 'package:Essbar/backend/Enums/Type.dart';
import 'package:Essbar/backend/databaseEntities/Ingredient.dart';
import 'dart:async';

/*
To find out how to run the tests, please read @HowToUse.txt
 */
Future<void> main() async {
  final dbHelper = DatabaseHelper.instance;

  test('get ingredients due to the preference type NotWanted', () async {
    List<PreferenceType> preferenceTypes = List<PreferenceType>();
    preferenceTypes.add(PreferenceType.NotWanted);
    List<Ingredient> ingredients =
        await PreferenceManager.getPreferencedIngredients(preferenceTypes);
    assert(ingredients != null);
  });

  test('get ingredients due to the preference type None', () async {
    List<PreferenceType> preferenceTypes = List<PreferenceType>();
    preferenceTypes.add(PreferenceType.None);
    List<Ingredient> ingredients =
        await PreferenceManager.getPreferencedIngredients(preferenceTypes);
    assert(ingredients != null);
  });

  test('get all available ingredients without a type', () async {
    List<Ingredient> ingredients =
        await PreferenceManager.getAllAvailableIngredients();
    assert(ingredients != null);
  });

  test('get all available ingredients with a specific type', () async {
    List<Ingredient> ingredients =
        await PreferenceManager.getAllAvailableIngredients(Type.General);
    assert(ingredients != null);
  });

  test('get existing ingredient and change preference type', () async {
    var resultSetIngredient = await dbHelper.customQuery(
        'select preferenceTypeId as pr_id from ingredient where name = "Hydroxocobalamin"');
    var dbItem = resultSetIngredient.first;
    var prId = dbItem['pr_id'] as int;
    ['The values before change PreferenceTypeId:', prId].forEach(print);

    //add map with ingredient with preferenceType to change
    Ingredient ingredientToTest = Ingredient("Hydroxocobalamin",
        PreferenceType.None, Type.Nutriment, DateTime.now());
    Map<Ingredient, PreferenceType> preferenceToChange = {
      ingredientToTest: PreferenceType.Preferred
    };

    //change preference
    PreferenceManager.changePreference(preferenceToChange);
    var resultSetIngredient1 = await dbHelper.customQuery(
        'select preferenceTypeId as pr_id from ingredient where name = "Hydroxocobalamin"');
    var dbItem1 = resultSetIngredient1.first;
    var prId1 = dbItem1['pr_id'] as int;
    ['The values after change PreferenceTypeId:', prId1].forEach(print);
  });

  test('get itemized scan results for the not existing item', () async {
    var scanResult = PreferenceManager.getItemizedScanResults(
        Product("Milch", "_imageUrl", "111111111111", DateTime.now()));
    assert(scanResult != null);
  });

  test('get itemized scan results for existing item', () async {
    Product product;
    await dbHelper
        .add(Product("Milch1", "_imageUrl", "2111111111111", DateTime.now()));
    var products = await dbHelper.readAll(DbTableNames.product);
    products.forEach((element) {
      product = element;
    });
    var scanResult = PreferenceManager.getItemizedScanResults(
        Product("Milch1", "_imageUrl", "2111111111111", DateTime.now()));
    assert(scanResult != null);
  });
}
