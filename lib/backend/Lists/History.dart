import '../database/DbTableNames.dart';
import '../database/DatabaseHelper.dart';
import '../Product.dart';
import './ProductList.dart';

import 'package:sortedmap/sortedmap.dart';
import 'package:event/event.dart';

class History extends ProductList{

  // Fields
  SortedMap<Product, DateTime> _historyOfScannedProducts = new SortedMap<Product, DateTime>();
  Event onUpdate = new Event();

  // Getter
  SortedMap<Product, DateTime> get historyOfScannedProducts => _historyOfScannedProducts;

  // Constructor
  History({int id}) : super(id, 'History'){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
  }

  // Methods
  void addProduct(Product product){
    bool productWasAlreadyInList = _historyOfScannedProducts.containsKey(product);
    _historyOfScannedProducts[product] = product.scanDate;
    if(!productWasAlreadyInList){
      Map<String, dynamic> row = Map();
      row['productId'] = product.id;
      row['listId'] = id;
      DatabaseHelper.instance.add(product, to: DbTableNames.productList, values: row);
    }
    onUpdate.broadcast();
  }

  void addAllProducts(List<Product> products){
    products.forEach((product) {
      addProduct(product);
    });
    onUpdate.broadcast();
  }

  void clearHistory(){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
    String tableName = DbTableNames.productList.name;
    DatabaseHelper.instance.customQuery('DELETE FROM $tableName WHERE listId = $id');
    onUpdate.broadcast();
  }

  @override
  List<Product> getProducts() {
    return _historyOfScannedProducts.keys.toList()?? new List<Product>();
  }
}