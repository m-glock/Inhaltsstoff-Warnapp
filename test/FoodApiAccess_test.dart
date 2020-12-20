import 'package:Inhaltsstoff_Warnapp/backend/FoodApiAccess.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Ingredient.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  FoodApiAccess foodApi = FoodApiAccess.instance;

  test('Scan a barcode and return a product object', () async {
    Product scannedProduct = await foodApi.scanProduct('4000400085115');
    assert(scannedProduct != null);
  });

  test('Scan a barcode for a product that does not exist', () async {
    Product scannedProduct = await foodApi.scanProduct('abcd');
    assert(scannedProduct == null);
  });

  /*test('Get all values for the tag allergens', () async {
    List<String> allergenNames = await foodApi.getAllValuesForTag('allergens');
    assert(allergenNames != null);
    assert(allergenNames.isNotEmpty);
  });*/

  test('Get all values for the tag allergies which does not exist in the database', () async {
    List<String> allergenNames = await foodApi.getAllValuesForTag('allergies');
    assert(allergenNames == null);
  });*/

  test('translate a list of one ingredient to german', () async {
    List<String> englishNames = List();
    englishNames.add('en:gluten');
    List<Ingredient> translatedNames = await foodApi.getIngredientsWithTranslatedNames(englishNames, 'allergens');

    assert(translatedNames[0].name.compareTo('Gluten') == 0);
  });

  test('a list of one ingredient cannot be translated, so the same name should be returned', () async {
    List<String> englishNames = List();
    englishNames.add('en:notexisting');
    List<Ingredient> translatedNames = await foodApi.getIngredientsWithTranslatedNames(englishNames, 'allergens');

    assert(translatedNames[0].name.compareTo('notexisting') == 0);
  });
}