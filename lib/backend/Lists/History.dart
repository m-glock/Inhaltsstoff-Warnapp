import '../database/DbTableNames.dart';
import '../database/DatabaseHelper.dart';

import 'ProductList.dart';
import '../Product.dart';
import 'package:sortedmap/sortedmap.dart';

class History extends ProductList{

  // Fields
  SortedMap<Product, DateTime> _historyOfScannedProducts = new SortedMap<Product, DateTime>();

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
  }

  void addAllProducts(List<Product> products){
    products.forEach((product) {
      addProduct(product);
    });
  }

  void clearHistory(){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
    String tableName = DbTableNames.productList.name;
    DatabaseHelper.instance.customQuery('DELETE FROM $tableName WHERE listId = $id');
  }

  @override
  List<Product> getProducts() {
    return _historyOfScannedProducts.keys.toList()?? new List<Product>();
  }
}