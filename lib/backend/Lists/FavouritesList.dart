import '../database/DbTableNames.dart';
import '../database/databaseHelper.dart';

import 'ProductList.dart';
import '../Product.dart';

class FavouritesList extends ProductList{

  // Fields
  List<Product> _favouriteProducts;

  // Getter
  List<Product> get favouriteProducts => _favouriteProducts;

  // Constructor
  FavouritesList(String name, {int id}) : super(id, name){
    _favouriteProducts = List();
  }

  // Methods
  bool addProduct(Product product){
    if(_favouriteProducts.contains(product)) {
      return false;
    }
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
    String tableName = DbTableNames.productList.name;
    int productId = product.id;
    DatabaseHelper.instance.customQuery('DELETE FROM $tableName WHERE productId = $productId AND listId = $id');
    _favouriteProducts.removeWhere((element) => element.compareTo(product) == 0);
  }

  @override
  List<Product> getProducts() {
    return _favouriteProducts;
  }
}