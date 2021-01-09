import 'package:Inhaltsstoff_Warnapp/backend/Lists/FavouriteList.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Lists/History.dart';

import '../Product.dart';
import '../database/DbTableNames.dart';
import '../database/DbTable.dart';

abstract class ProductList extends DbTable{

  // Fields
  String _name;
  ProductList _parentList;

  // Getter
  get name => _name;
  get parentList => _parentList;

  // Constructor
  ProductList(int id, this._name, {ProductList parentList}) : super(id){
    _parentList = parentList;
  }

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
    map['parentId'] = _parentList.id;

    return map;
  }

  static DbTable fromMap(Map<String, dynamic> data) {
    ProductList parentList;

    if(data['name'] == 'History') return History(id: data['id']);
    else return FavouriteList(data['name'], id: data['id'], parent: parentList);
  }

  List<Product> getProducts();

}