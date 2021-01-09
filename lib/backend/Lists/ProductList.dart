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
    // TODO: implement toMap
    throw UnimplementedError();
  }

  static DbTable fromMap(Map<String, dynamic> data) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  List<Product> getProducts();

}