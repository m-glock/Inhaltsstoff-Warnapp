import '../../enums/DbTableNames.dart';
import '../FavouritesList.dart';
import '../History.dart';
import '../Product.dart';
import './DbTable.dart';

abstract class DbList extends DbTable {
  String _name;

  get name => _name;

  DbList(int id, this._name) : super(id);

  /*
  * Method for sub classes to implement.
  * @return a list of all products contained in the list
  * */
  List<Product> getProducts();

  // Methods from the super class
  @override
  String getTableName() {
    return DbTableNames.list.name;
  }

  @override
  Future<Map<String, dynamic>> toMap({bool withId = true}) async {
    final map = new Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;

    return map;
  }

  static DbTable fromMap(Map<String, dynamic> data) {
    if (data['name'] == 'History')
      return History(id: data['id']);
    else
      return FavouritesList(data['name'], id: data['id']);
  }
}
