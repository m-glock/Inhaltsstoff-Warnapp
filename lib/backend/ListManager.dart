import 'database/DbTableNames.dart';
import 'database/databaseHelper.dart';

import 'Lists/FavouriteList.dart';
import 'Lists/History.dart';

class ListManager{

  // Fields
  History _history;
  FavouriteList _favouriteList;

  // Getter
  get history => _history;
  get favouriteList => _favouriteList;

  // make this a singleton class
  ListManager._privateConstructor() {
    DatabaseHelper helper = DatabaseHelper.instance;

    // get history object from DB and all products saved there
    helper.read(DbTableNames.list, ['History'], whereColumn: 'name').then((value) => _history = value as History);
    helper.readAll(DbTableNames.productList, whereColumn: 'listId', whereArgs: [_history.id]).then((value) => _history.addAllProducts(value));

    // get favourites object from DB and all products saved there
    helper.read(DbTableNames.list, ['Favourites'], whereColumn: 'name').then((value) => _favouriteList = value as FavouriteList);
    helper.readAll(DbTableNames.productList, whereColumn: 'listId', whereArgs: [_favouriteList.id]).then((value) => _favouriteList.addAllProducts(value));
  }

  static final ListManager instance = ListManager._privateConstructor();
}