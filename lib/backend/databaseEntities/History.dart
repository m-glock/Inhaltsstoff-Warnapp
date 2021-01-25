import '../enums/DbTableNames.dart';
import '../database/DatabaseHelper.dart';
import 'Product.dart';
import 'superClasses/DbList.dart';

import 'package:sortedmap/sortedmap.dart';
import 'package:event/event.dart';

class History extends DbList{

  // Fields
  SortedMap<Product, DateTime> _historyOfScannedProducts = new SortedMap<Product, DateTime>();
  Event onUpdate = new Event();

  // Constructor
  History({int id}) : super(id, 'History'){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
  }

  /*
  * Add a product to the history.
  * @param product: the product to be added
  * */
  void addProduct(Product product){
    // add relation of product to database if it was not in history before
    if(!_historyOfScannedProducts.containsKey(product)){
      Map<String, dynamic> row = Map();
      row['productId'] = product.id;
      row['listId'] = id;
      DatabaseHelper.instance.add(product, DbTableNames.productList, row);
    }

    // update scan date of product or add product to list if it was not there
    _historyOfScannedProducts[product] = product.scanDate;

    // notify the FE of the change
    onUpdate.broadcast();
  }

  /*
  * Add multiple products to the history.
  * @param products: list of products to be added
  * */
  void addAllProducts(List<Product> products){
    products.forEach((product) {
      addProduct(product);
    });

    // notify the FE of the change
    onUpdate.broadcast();
  }

  /*
  * Remove all elements from the history.
  * */
  void clearHistory(){
    // clear the list
    _historyOfScannedProducts = SortedMap(Ordering.byValue());

    // remove all relations from this list from the database
    String tableName = DbTableNames.productList.name;
    DatabaseHelper.instance.customQuery('DELETE FROM $tableName WHERE listId = $id');

    // notify the FE of the change
    onUpdate.broadcast();
  }

  /*
  * Implement method of super class to get all products from this list.
  * As the Map is sorted in ascending order, it will be reversed before returning the keys
  * @return a list of all product objects in this list
  * */
  @override
  List<Product> getProducts() {
    return _historyOfScannedProducts.keys.toList().reversed.toList()
        ?? new List<Product>();
  }
}