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
  ListManager._privateConstructor(){
    // TODO get from DB
    _history = History();
    _favouriteList = FavouriteList('Main');
  }
  static final ListManager instance = ListManager._privateConstructor();
}