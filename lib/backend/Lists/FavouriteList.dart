import 'ProductList.dart';
import '../Product.dart';

class FavouriteList extends ProductList{

  // Fields
  List<Product> _favouriteProducts;

  // Getter
  get favouriteProducts => _favouriteProducts;

  // Constructor
  FavouriteList(String name, {int id}) : super(id, name){
    _favouriteProducts = List();
  }

  // Methods
  bool addToFavourites(Product product){
    if(_favouriteProducts.contains(product)) return false;

    //TODO add in DB
    _favouriteProducts.add(product);
    return true;
  }

  void removeFromFavourites(Product product){
    //TODO remove from DB
    _favouriteProducts.removeWhere((element) => element.compareTo(product) == 0);
  }

  @override
  List<Product> getProducts() {
    return _favouriteProducts;
  }
}