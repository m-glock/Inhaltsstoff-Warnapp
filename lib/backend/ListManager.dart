import 'Product.dart';
import 'database/DbTable.dart';
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
  ListManager._privateConstructor();
  static final ListManager instance = ListManager._privateConstructor();

  Future<void> init() async {
    DatabaseHelper helper = DatabaseHelper.instance;

    _history = await helper.read(DbTableNames.list, ['History'], whereColumn: 'name');
    List<DbTable> historyResults = await helper.readAll(DbTableNames.productList, whereColumn: 'listId', whereArgs: [_history.id]);
    List<Product> historyProducts = historyResults.map((e) => e = e as Product).toList();
    _history.addAllProducts(historyProducts);

    _favouriteList = await helper.read(DbTableNames.list, ['Favourites'], whereColumn: 'name');
    List<DbTable> favouriteResults = await helper.readAll(DbTableNames.productList, whereColumn: 'listId', whereArgs: [_favouriteList.id]);
    List<Product> favouriteProducts = favouriteResults.map((e) => e = e as Product).toList();
    _favouriteList.addAllProducts(favouriteProducts);
  }

}