import 'package:Essbar/backend/database/DatabaseHelper.dart';
import 'package:Essbar/backend/FoodApiAccess.dart';
import 'package:Essbar/backend/Product.dart';
import 'package:flutter_test/flutter_test.dart';

/*
To find out how to run the tests, please read @HowToUse.txt
 */
void main() {
  FoodApiAccess foodApi = FoodApiAccess.instance;
  final dbHelper = DatabaseHelper.instance;

  test('Scan a barcode and return a product object', () async {
    Product scannedProduct = await foodApi.scanProduct('4000400085115');
    assert(scannedProduct != null);
  });

  test('Scan a barcode for a product that does not exist', () async {
    Product scannedProduct = await foodApi.scanProduct('abcd');
    assert(scannedProduct == null);
  });

  test('Do not get the product, because it is not exist in the db', () async {
    var product = (await foodApi.scanProduct("1234566789"));
    assert(product == null);
  });

  test('Get the product, because it exists in the db', () async {
    await dbHelper.add(
        Product("TestProduct", "_imageUrl", "2111111111112", DateTime.now()));

    var product = (await foodApi.scanProduct("2111111111112"));
    assert(product != null);
  });

  test('translate a list of ingredients to german and get allergens', () async {
    var allergens = await foodApi.translationManager.getTranslatedValuesForTag('allergens');
    assert(allergens.contains("Schwefeldioxid und Sulfite"));
  });
}
