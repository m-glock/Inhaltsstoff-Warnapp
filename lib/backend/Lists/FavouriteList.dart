import 'ProductList.dart';
import '../Product.dart';

class FavouriteList extends ProductList{

  // Fields
  static Map<Product, String> _favouriteProducts;
  static List<String> _favouriteCategories;

  // Getter
  static get favouriteProducts => _favouriteProducts;
  static get categories => _favouriteCategories;

  // Constructor
  FavouriteList({int id}) : super(id){
    _favouriteProducts = Map();
    _favouriteCategories = List();
  }

  // Methods
  bool addToFavourites(Product product, {String category = 'None'}){
    if(!_favouriteCategories.contains(category)) _favouriteCategories.add(category);
    if(_favouriteProducts.containsKey(product)) return false;

    _favouriteProducts[product] = category;
    return true;
  }

  void removeFromFavourites(Product product){
    _favouriteProducts.removeWhere((key, value) => key.compareTo(product) == 0);
  }

  void changeCategoryOfProduct(Product product, String newCategory){
    _favouriteProducts[product] = newCategory;
  }

  bool addCategory(String name){
    if(_favouriteCategories.contains(name)) return false;

    _favouriteCategories.add(name);
    return true;
  }

  void removeCategory(String name) {
    _favouriteCategories.remove(name);
  }

}