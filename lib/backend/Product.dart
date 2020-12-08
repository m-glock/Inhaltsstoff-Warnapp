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
  DateTime _lastUpdated;
  String _nutriscore;

  List<Ingredient> _ingredients;
  List<Ingredient> _traces;

  double _quantity;
  String _origin;
  String _manufacturingPlaces;
  String _stores;

  // Getter
  String get name => _name;
  Map<Ingredient, ScanResult> get itemizedScanResults => _itemizedScanResults;
  String get imageUrl => _imageUrl;
  String get barcode => _barcode;
  DateTime get scanDate => _scanDate;
  DateTime get lastUpdated => _lastUpdated;
  String get nutriscore => _nutriscore;

  List<Ingredient> get ingredients => _ingredients;
  List<Ingredient> get traces => _traces;

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
    newProduct._quantity = quantityString.isEmpty ? 0 : double.parse(quantityString);
    newProduct._origin = json['origins'];
    newProduct._manufacturingPlaces = json['manufacturing_places'];
    newProduct._stores = json['stores'];

    // add Ingredients, Allergens, Vitamins, Additives and Traces
    List<Ingredient> ingredients = List();
    List<dynamic> ingredientNames = json['ingredients_tags'];
    ingredients = await FoodApiAccess.getIngredientsWithTranslatedNames(ingredientNames, 'ingredients');

    var allergenNames = json['allergens_tags'];
    ingredients.addAll(await FoodApiAccess.getIngredientsWithTranslatedNames(allergenNames, 'allergens'));

    List<dynamic> vitaminNames = json['vitamins_tags'];
    ingredients.addAll(await FoodApiAccess.getIngredientsWithTranslatedNames(vitaminNames, 'vitamins'));

    List<dynamic> additiveNames = json['additives_tags'];
    ingredients.addAll(await FoodApiAccess.getIngredientsWithTranslatedNames(additiveNames, 'additives'));

    newProduct._ingredients = ingredients;

    List<dynamic> tracesNames = json['traces_tags'];
    newProduct._traces = await FoodApiAccess.getIngredientsWithTranslatedNames(tracesNames, 'ingredients');

    //TODO set itemizedScanResults with PreferenceManager, right now only dummy data
    Map<Ingredient, ScanResult> itemized = Map();
    itemized[Ingredient('Senf', Type.Allergen)] = ScanResult.Red;
    itemized[Ingredient('Vitamin B', Type.Vitamin)] = ScanResult.Green;
    itemized[Ingredient('Wasser', Type.Nutriment)] = ScanResult.Red;
    itemized[Ingredient('Vitamin c', Type.Vitamin)] = ScanResult.Green;
    itemized[Ingredient('Milch', Type.Allergen)] = ScanResult.Red;
    itemized[Ingredient('E254', Type.Additive)] = ScanResult.Yellow;
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
  * get the names of ingredients that are responsible for the overall scan result.
  * Either return the responsible ingredients that are not wanted or those that are explicitly wanted
  * @param unwantedIngredients: determines whether to return the ingredients that cause a negative scan result (unwanted)
  *                             or those that are explicitly wanted by the user and contained in the product
  * @return: a list of ingredient names
  * TODO implement, right now only dummy data
  * */
  List<String> getDecisiveIngredientNames(bool unwantedIngredients){
    if(unwantedIngredients){
      List<String> unwanted = List();
      unwanted.add('Schokolade');
      unwanted.add('Milch');
      return unwanted;
    } else {
      List<String> wanted = List();
      wanted.add('Vitamin C');
      wanted.add('Magnesium');
      return wanted;
    }
  }
}