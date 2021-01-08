import 'ProductList.dart';
import '../Product.dart';

class History extends ProductList{

  // Fields
  List<Product> _historyOfScannedProducts;

  // Getter
  get historyOfScannedProducts => _historyOfScannedProducts;

  // Constructor
  History({int id}) : super(id){
    _historyOfScannedProducts = List();
  }

  // Methods
  void addToHistory(Product product){
    // TODO: implement addToHistory
    throw UnimplementedError();
  }

  static void clearHistory(){
    // TODO: implement clearHistory
    throw UnimplementedError();
  }

}