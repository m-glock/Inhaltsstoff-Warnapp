import 'package:Inhaltsstoff_Warnapp/backend/FoodApiAccess.dart';

import 'Ingredient.dart';
import 'ScanResult.dart';
import 'Type.dart';

class Product{

  String _name;
  Map<Ingredient, ScanResult> _itemizedScanResults;
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
  Map<Ingredient, ScanResult> get itemizedScanResult => _itemizedScanResults;
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
  Product(this._name, this._imageUrl, this._barcode, this._scanDate);

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

    Product newProduct = Product(name, imageUrl, barcode, scanDate);

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

    //TODO set itemizedScanResults, right now only dummy data
    Map<Ingredient, ScanResult> itemized = Map();
    itemized[Ingredient('Senf', Type.Allergen)] = ScanResult.Red;
    itemized[Ingredient('Vitamin B', Type.Vitamin)] = ScanResult.Green;
    newProduct._itemizedScanResults = itemized;


    return newProduct;
  }

  /*
   * determine the overall ScanResult for this product.
   * If any Ingredient is red, return red
   * If any Ingredient is yellow, but none red, return yellow
   * if all Ingredients are green, return green
   * @return: the ScanResult for this product
   */
  ScanResult getOverallScanResult(){
    //TODO implement
    return ScanResult.Yellow;
  }

  /*
  * find all Ingredients that the user explicity wants and that the product contains
  * @return a list of ingredients
  * */
  List<Ingredient> getExplicitlyWantedIngredients(){
    //TODO implement
    List nutriments = List();
    nutriments.add(Ingredient('Vitamin C', Type.Vitamin));
    nutriments.add(Ingredient('Vitamin B', Type.Vitamin));
    return nutriments;
  }

  /*
  * find all Ingredients that the user does not want and that the product contains
  * @return a list of ingredients
  * */
  List<Ingredient> getUnwantedIngredients(){
    //TODO implement
    List ingredients = List();
    ingredients.add(Ingredient('Senf', Type.Allergen));
    ingredients.add(Ingredient('Vitamin B', Type.Additive));
    return ingredients;
  }
}