import 'package:Inhaltsstoff_Warnapp/backend/PreferenceManager.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Ingredient.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Product.dart';
import 'package:Inhaltsstoff_Warnapp/backend/database/databaseHelper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{

  final dbHelper = DatabaseHelper.instance;
  final db = await dbHelper.database;

  /*
  example

  test('Scan a barcode and return a product object', () async {
    Product scannedProduct = await foodApi.scanProduct('4000400085115');
    assert(scannedProduct != null);
  });
   */

}