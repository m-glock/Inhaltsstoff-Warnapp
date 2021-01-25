import 'Product.dart';
import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'database/DatabaseHelper.dart';

import 'Lists/FavouritesList.dart';
import 'Lists/History.dart';

class ListManager{

  // Fields
  FavouritesList _favouritesList;
  History _history;
  Future<void> _initialisedPromise;

  // Getter
  Future<History> get history async {
    if (_initialisedPromise != null) {
      await _initialisedPromise;
    }

    return _history;
  }

  Future<FavouritesList> get favouritesList async {
    if (_initialisedPromise != null) {
      await _initialisedPromise;
    }

    return _favouritesList;
  }

  // make this a singleton class
  ListManager._privateConstructor() {
    _initialisedPromise = init();
    _initialisedPromise.then((value) => _initialisedPromise = null);
  }
  static final ListManager instance = ListManager._privateConstructor();

  Future<void> init() async {
    DatabaseHelper helper = DatabaseHelper.instance;

    _history = await helper.read(DbTableNames.list, ['History'], whereColumn: 'name');
    List<DbTable> historyResults = await helper.readAll(DbTableNames.productList, 'listId', [_history.id]);
    List<Product> historyProducts = historyResults.map((e) => e = e as Product).toList();
    _history.addAllProducts(historyProducts);

    _favouritesList = await helper.read(DbTableNames.list, ['Favourites'], whereColumn: 'name');
    List<DbTable> favouriteResults = await helper.readAll(DbTableNames.productList, 'listId', [_favouritesList.id]);
    List<Product> favouriteProducts = favouriteResults.map((e) => e = e as Product).toList();
    _favouritesList.addAllProducts(favouriteProducts);
  }

}