import 'package:Essbar/backend/ListManager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

/*
To find out how to run the tests, please read @HowToUse.txt
 */
Future<void> main() async {
  ListManager listManager = ListManager.instance;

  //before start this test, please start at first FoodApiAccess and PreferenceManagerTest
  test('get history', () async {
    var history = await listManager.history;
    assert(history.historyOfScannedProducts != null);
  });

  test('no favourites configured, get nothing', () async {
    var favouritesList = await listManager.favouritesList;
    assert(favouritesList.getProducts().isEmpty);
  });

  test('clear history and get empty history', () async {
    var history = await listManager.history;
    history.clearHistory();
    assert(history.historyOfScannedProducts.isEmpty);
  });
}
