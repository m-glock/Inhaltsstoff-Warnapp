import 'ProductList.dart';
import '../Product.dart';
import 'package:sortedmap/sortedmap.dart';

class History extends ProductList{

  // Fields
  SortedMap<Product, DateTime> _historyOfScannedProducts;

  // Getter
  get historyOfScannedProducts => _historyOfScannedProducts;

  // Constructor
  History({int id}) : super(id){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
  }

  // Methods
  void addToHistory(Product product){
    _historyOfScannedProducts[product] = product.scanDate;
  }

  void clearHistory(){
    _historyOfScannedProducts = SortedMap(Ordering.byValue());
  }

}