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
    _history = History();
    _favouriteList = FavouriteList();
  }
  static final ListManager instance = ListManager._privateConstructor();
}