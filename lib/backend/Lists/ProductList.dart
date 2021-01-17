import 'FavouritesList.dart';
import 'History.dart';

import '../Product.dart';
import '../database/DbTableNames.dart';
import '../database/DbTable.dart';

abstract class ProductList extends DbTable{

  // Fields
  String _name;

  // Getter
  get name => _name;

  // Constructor
  ProductList(int id, this._name) : super(id);

  // Methods
  @override
  DbTableNames getTableName() {
    return DbTableNames.list;
  }

  @override
  Map<String, dynamic> toMap({bool withId = true}) {
    final map = new Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;

    return map;
  }

  static DbTable fromMap(Map<String, dynamic> data) {
    if(data['name'] == 'History') return History(id: data['id']);
    else return FavouritesList(data['name'], id: data['id']);
  }

  List<Product> getProducts();

}