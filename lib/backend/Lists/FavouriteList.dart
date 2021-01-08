import 'ProductList.dart';
import '../Product.dart';

class FavouriteList extends ProductList{

  // Fields
  static Map<Product, String> _favouriteProducts;
  static List<String> _favouriteCategories;

  // Getter
  static get favouriteProducts => _favouriteProducts;
  // TODO category to DB
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

    //TODO add in DB
    _favouriteProducts[product] = category;
    return true;
  }

  void removeFromFavourites(Product product){
    //TODO remove from DB
    _favouriteProducts.removeWhere((key, value) => key.compareTo(product) == 0);
  }

  void changeCategoryOfProduct(Product product, String newCategory){
    //TODO update in DB
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

  @override
  List<Product> getProducts() {
    return _favouriteProducts.keys;
  }
}