import 'package:Essbar/backend/ListManager.dart';
import 'package:Essbar/backend/database/DatabaseHelper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

/*
How to run the tests? Please read @HowToUse.txt
 */
Future<void> main() async {
  final dbHelper = DatabaseHelper.instance;
  final db = await dbHelper.database;
  ListManager listManager = ListManager.instance;

  //before start this test, please start at first FoodApiAccess and PreferenceManagerTest
  test('get history', () async {
    var history = await listManager.history;
    //print(history.historyOfScannedProducts.values);
    assert(history.historyOfScannedProducts != null);
  });

  test('no favourites configured, get nothing', () async {
    var favouritesList = await listManager.favouritesList;
    //print(favouritesList.getProducts());
    assert(favouritesList.getProducts().isEmpty);
  });

  test('clear history and get empty history', () async {
    var history = await listManager.history;
    history.clearHistory();
    //print(history.historyOfScannedProducts.values);
    assert(history.historyOfScannedProducts.isEmpty);
  });
}
