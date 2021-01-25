import './database/DatabaseHelper.dart';
import './databaseEntities/superClasses/DbTable.dart';
import './databaseEntities/FavouritesList.dart';
import './databaseEntities/History.dart';
import './databaseEntities/Product.dart';
import './enums/DbTableNames.dart';

class ListManager{

  FavouritesList _favouritesList;
  History _history;
  Future<void> _initialisedPromise;

  Future<History> get history async {
    // check if lists have been initialized before accessing them
    if (_initialisedPromise != null) {
      await _initialisedPromise;
    }

    return _history;
  }

  Future<FavouritesList> get favouritesList async {
    // check if lists have been initialized before accessing them
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

  /*
  * Initialize the favourites lists and the history
  * and add all related elements from the database
  * */
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