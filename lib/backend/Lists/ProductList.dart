import '../Product.dart';
import '../database/DbTableNames.dart';
import '../database/DbTable.dart';

abstract class ProductList extends DbTable{

  // constructor
  ProductList(int id) : super(id);

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