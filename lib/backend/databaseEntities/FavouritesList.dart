import 'package:event/event.dart';

import '../database/DatabaseHelper.dart';
import '../enums/DbTableNames.dart';
import './superClasses/DbList.dart';
import './Product.dart';

class FavouritesList extends DbList {
  List<Product> _favouriteProducts = new List<Product>();
  Event onUpdate = new Event();

  FavouritesList(String name, {int id}) : super(id, name) {
    _favouriteProducts = List();
  }

  /*
  * Add a product to the favourites lists.
  * @param product: the product to be added
  * @return true if the product has been added
  *         or false if it was already in the list and has not been added
  * */
  bool addProduct(Product product) {
    // check if product is already in the list
    if (_favouriteProducts.contains(product)) {
      return false;
    }
    _favouriteProducts.add(product);

    // add relation between product and favourites list to the database
    Map<String, dynamic> row = Map();
    row['productId'] = product.id;
    row['listId'] = id;
    DatabaseHelper.instance.add(product, DbTableNames.productList, row);

    // notify frontend that list has been updated
    onUpdate.broadcast();

    return true;
  }

  /*
  * Add multiple products to the favourites lists.
  * @param products: list of products to be added
  * */
  void addAllProducts(List<Product> products) {
    products.forEach((product) {
      addProduct(product);
    });

    // notify the FE of the change
    onUpdate.broadcast();
  }

  /*
  * Remove a product from the list.
  * @param product: the product to be removed
  * */
  void removeProduct(Product product) {
    // remove product from the database
    String tableName = DbTableNames.productList.name;
    int productId = product.id;
    DatabaseHelper.instance.customQuery(
        'DELETE FROM $tableName WHERE productId = $productId AND listId = $id');

    // remove the product from the list
    _favouriteProducts
        .removeWhere((element) => element.compareTo(product) == 0);

    // notify the FE of the change
    onUpdate.broadcast();
  }

  /*
  * Implement method of super class to get all products from this list.
  * @return a list of all product objects in this list
  * */
  @override
  List<Product> getProducts() {
    return _favouriteProducts;
  }
}
