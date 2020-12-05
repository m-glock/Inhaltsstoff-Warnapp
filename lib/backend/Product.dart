import 'package:Inhaltsstoff_Warnapp/backend/FoodApiAccess.dart';

import 'Ingredient.dart';
import 'ScanResult.dart';

class Product{

  String _name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime _scanDate;

  List<Ingredient> _ingredients;
  //List<Ingredient> _nutriments;
  List<Ingredient> _allergens;
  List<Ingredient> _vitamins;
  List<Ingredient> _additives;
  DateTime _lastUpdated;
  List<Ingredient> _traces;
  String _nutriscore;

  double _quantity;
  String _origin;
  String _manufacturingPlaces;
  String _stores;

  // Getter
  String get name => _name;
  ScanResult get scanResult => _scanResult;
  String get imageUrl => _imageUrl;
  String get barcode => _barcode;
  DateTime get scanDate => _scanDate;

  List<Ingredient> get ingredients => _ingredients;
  //List<Ingredient> get nutriments => _nutriments;
  List<Ingredient>  get allergens => _allergens;
  List<Ingredient> get vitamins => _vitamins;
  List<Ingredient> get additives => _additives;
  DateTime get lastUpdated => _lastUpdated;
  List<Ingredient> get traces => _traces;
  String get nutriscore => _nutriscore;

  double get quantity => _quantity;
  String get origin => _origin;
  String get manufacturingPlaces => _manufacturingPlaces;
  String get stores => _stores;


  // constructor with minimal necessary information
  Product(this._name, this._scanResult, this._imageUrl, this._barcode, this._scanDate);

  /*
  * Uses the json from the Food API to create a new Product object
  * @param json: the json that the food API returns for a barcode
  * @return: a new Product object
  * */
  static Future<Product> fromApiJson(Map<String, dynamic> json) async {
    String name = json['product_name'];
    String imageUrl = json['image_url'];
    String barcode = json['code'];
    DateTime scanDate = DateTime.now();

    Product newProduct = Product(name, null, imageUrl, barcode, scanDate);

    // add other information
    var dateTime = json['last_modified_t'] * 1000;
    newProduct._lastUpdated = DateTime.fromMillisecondsSinceEpoch(dateTime);
    newProduct._nutriscore = json['nutriscore_grade'];

    String quantityString = (json['quantity'] as String).trim().replaceAll(new RegExp('[a-zA-Z]'), '');
    newProduct._quantity = double.parse(quantityString);
    newProduct._origin = json['origins'];
    newProduct._manufacturingPlaces = json['manufacturing_places'];
    newProduct._stores = json['stores'];

    // add Ingredients, Nutriments, Allergens, Vitamins, Additives and Traces
    List<dynamic> ingredientNames = json['ingredients_tags'];
    newProduct._ingredients = await FoodApiAccess.getIngredientsWithTranslatedNames(ingredientNames, 'ingredients');

    /*var nutrimentNames = json['nutriments_tags'];
    newProduct._nutriments = await FoodApiAccess.getIngredientsWithTranslatedNames(nutrimentNames, 'nutriments');*/

    var allergenNames = json['allergens_tags'];
    newProduct._allergens = await FoodApiAccess.getIngredientsWithTranslatedNames(allergenNames, 'allergens');

    List<dynamic> vitaminNames = json['vitamins_tags'];
    newProduct._vitamins = await FoodApiAccess.getIngredientsWithTranslatedNames(vitaminNames, 'vitamins');

    List<dynamic> additiveNames = json['additives_tags'];
    newProduct._additives = await FoodApiAccess.getIngredientsWithTranslatedNames(additiveNames, 'additives');

    List<dynamic> tracesNames = json['traces_tags'];
    newProduct._traces = await FoodApiAccess.getIngredientsWithTranslatedNames(tracesNames, 'ingredients');

    return newProduct;
  }

}