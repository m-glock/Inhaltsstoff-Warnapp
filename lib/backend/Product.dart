import 'package:Inhaltsstoff_Warnapp/backend/FoodApiAccess.dart';
import 'package:Inhaltsstoff_Warnapp/backend/database/DbTable.dart';
import 'package:Inhaltsstoff_Warnapp/backend/database/DbTableNames.dart';

import 'Ingredient.dart';
import 'Enums/ScanResult.dart';

class Product extends DbTable{

  String _name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime _scanDate;
  DateTime _lastUpdated;
  String _nutriscore;

  List<Ingredient> _ingredients;
  List<Ingredient> _traces;

  String _quantity;
  String _origin;
  String _manufacturingPlaces;
  String _stores;

  // Getter
  String get name => _name;
  ScanResult get scanResult => _scanResult;
  String get imageUrl => _imageUrl;
  String get barcode => _barcode;
  DateTime get scanDate => _scanDate;
  DateTime get lastUpdated => _lastUpdated;
  String get nutriscore => _nutriscore;

  List<Ingredient> get ingredients => _ingredients;
  List<Ingredient> get traces => _traces;

  String get quantity => _quantity;
  String get origin => _origin;
  String get manufacturingPlaces => _manufacturingPlaces;
  String get stores => _stores;


  // constructor with minimal necessary information
  Product(this._name, this._imageUrl, this._barcode, this._scanDate, {int id})
      : super(id);

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

    newProduct._quantity = json['quantity'];
    newProduct._origin = json['origins'];
    newProduct._manufacturingPlaces = json['manufacturing_places'];
    newProduct._stores = json['stores'];

    // add Ingredients, Allergens, Vitamins, Additives and Traces
    FoodApiAccess api = FoodApiAccess.instance;
    List<Ingredient> ingredients = List();
    FoodApiAccess foodApi = FoodApiAccess.instance;
    List<dynamic> ingredientNames = json['ingredients_tags'];
    ingredients = await foodApi.getIngredientsWithTranslatedNames(ingredientNames, 'ingredients');

    var allergenNames = json['allergens_tags'];
    ingredients.addAll(await foodApi.getIngredientsWithTranslatedNames(allergenNames, 'allergens'));

    List<dynamic> vitaminNames = json['vitamins_tags'];
    ingredients.addAll(await foodApi.getIngredientsWithTranslatedNames(vitaminNames, 'vitamins'));

    List<dynamic> additiveNames = json['additives_tags'];
    ingredients.addAll(await foodApi.getIngredientsWithTranslatedNames(additiveNames, 'additives'));

    newProduct._ingredients = ingredients;

    List<dynamic> tracesNames = json['traces_tags'];
    newProduct._traces = await foodApi.getIngredientsWithTranslatedNames(tracesNames, 'ingredients');

    //TODO use itemizedScanResults in PreferenceManager to get the overall scanresult, right now only dummy data
    newProduct._scanResult = ScanResult.Yellow;

    return newProduct;
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

  // DB methods
  @override
  DbTableNames getTableName() {
    return DbTableNames.product;
  }

  @override
  Map<String, dynamic> toMap({bool withId = true}) {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  static Product fromMap(Map<String, dynamic> data) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }
}