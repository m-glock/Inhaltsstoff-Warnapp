import '../database/DbTableNames.dart';
import '../database/databaseHelper.dart';

import 'ProductList.dart';
import '../Product.dart';

class FavouriteList extends ProductList{

  // Fields
  List<Product> _favouriteProducts;

  // Getter
  get favouriteProducts => _favouriteProducts;

  // Constructor
  FavouriteList(String name, {int id, ProductList parent}) : super(id, name, parentList: parent){
    _favouriteProducts = List();
  }

  // Methods
  bool addProduct(Product product){
    if(_favouriteProducts.contains(product)) return false;
    _favouriteProducts.add(product);

    Map<String, dynamic> row = Map();
    row['productId'] = product.id;
    row['listId'] = id;
    DatabaseHelper.instance.add(product, to: DbTableNames.productList, values: row);

    return true;
  }

  void addAllProducts(List<Product> products){
    products.forEach((product) {
      addProduct(product);
    });
  }

  void removeProduct(Product product){
    DatabaseHelper.instance.delete(product, from: DbTableNames.productList, whereColumn: 'listId', whereArgs: [id]);
    _favouriteProducts.removeWhere((element) => element.compareTo(product) == 0);
  }

  @override
  List<Product> getProducts() {
    return _favouriteProducts;
  }
}