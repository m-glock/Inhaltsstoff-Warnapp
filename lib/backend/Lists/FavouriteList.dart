import 'ProductList.dart';
import '../Product.dart';

class FavouriteList extends ProductList{

  // Fields
  static Set<Product> _favouriteProducts;
  static List<String> _favouriteCategories;

  // Getter
  static get favouriteProducts => _favouriteProducts;
  static get categories => _favouriteCategories;

  // Constructor
  FavouriteList({int id}) : super(id){
    _favouriteProducts = Set();
    _favouriteCategories = List();
  }

  // Methods
  void addToFavourites(Product product){
    _favouriteProducts.add(product);
  }

  void removeFromFavourites(Product product){
    _favouriteProducts.removeWhere((element) => element.equals(product));
  }

  void addCategory(String name){
    // TODO: implement addCategory
    throw UnimplementedError();
  }

  void removeCategory(String name) {
    // TODO: implement removeCategory
    throw UnimplementedError();
  }

}