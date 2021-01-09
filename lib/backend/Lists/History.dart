import '../database/DbTableNames.dart';
import '../database/databaseHelper.dart';

import 'ProductList.dart';
import '../Product.dart';
import 'package:sortedmap/sortedmap.dart';

class History extends ProductList{

  // Fields
  SortedMap<Product, DateTime> _historyOfScannedProducts;

  // Getter
  get historyOfScannedProducts => _historyOfScannedProducts;

  // Constructor
  History({int id}) : super(id, 'History'){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
  }

  // Methods
  void addProduct(Product product){
    _historyOfScannedProducts[product] = product.scanDate;
    Map<String, dynamic> row = Map();
    row['productId'] = product.id;
    row['listId'] = id;
    DatabaseHelper.instance.add(product, to: DbTableNames.productList, values: row);
  }

  void addAllProducts(List<Product> products){
    products.forEach((product) {
      addProduct(product);
    });
  }

  void clearHistory(){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
    // TODO remove from DB
  }

  @override
  List<Product> getProducts() {
    return _historyOfScannedProducts.keys;
  }
}