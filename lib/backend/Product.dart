import 'package:sqflite/sqflite.dart';

import 'database/databaseHelper.dart';
import 'database/DbTable.dart';
import 'database/DbTableNames.dart';
import 'Enums/ScanResult.dart';
import 'FoodApiAccess.dart';
import 'Ingredient.dart';

class Product extends DbTable{

  String _name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime _scanDate;
  DateTime _lastUpdated;
  String _nutriscore;

  List<Ingredient> _ingredients;

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

  String get quantity => _quantity;
  String get origin => _origin;
  String get manufacturingPlaces => _manufacturingPlaces;
  String get stores => _stores;


  // constructor with minimal necessary information
  Product(this._name, this._imageUrl, this._barcode, this._scanDate, {int id}) : super(id) {
    _ingredients = List();
  }

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
    FoodApiAccess foodApi = FoodApiAccess.instance;
    Set<String> translatedIngredientNames = Set();

    var allergenNames = json['allergens_tags'];
    translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('allergens', tagValues: allergenNames));

    List<dynamic> vitaminNames = json['vitamins_tags'];
    translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('vitamins', tagValues: vitaminNames));

    List<dynamic> mineralNames = json['minerals_tags'];
    translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('minerals', tagValues: mineralNames));

    List<dynamic> ingredientNames = json['ingredients_tags'];
    translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('ingredients', tagValues: ingredientNames));

    for(String name in translatedIngredientNames) {
      newProduct._ingredients.add(await DatabaseHelper.instance.read(DbTableNames.ingredient, [name], whereColumn: 'name'));
    }

    // TODO: additives as separate field or inside of ingredients?
    //List<dynamic> additiveNames = json['additives_tags'];
    //newProduct.addAll(await foodApi.getIngredientsWithTranslatedNames(additiveNames, 'additives'));

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

  Future<int> saveInDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.add(this);
    this.id = id;

    // save each ingredients connection to the product in productingredient
    Database db = await helper.database;
    for(Ingredient ingredient in _ingredients) {
      Map<String, dynamic> values = Map();
      values['productId'] = this.id;
      values['ingredientId'] = ingredient.id;
      db.insert(DbTableNames.productIngredient.name, values);
    }

    return id;
  }

  // DB methods
  @override
  DbTableNames getTableName() {
    return DbTableNames.product;
  }

  @override
  Map<String, dynamic> toMap({bool withId = true}) {
    final map = new Map<String, dynamic>();
    map['scanResultId'] = _scanResult.id;
    map['name'] = name;
    map['imageUrl'] = _imageUrl;
    map['barcode'] = _barcode;
    map['scanDate'] = _scanDate.toIso8601String();
    map['lastUpdated'] = _lastUpdated.toIso8601String();
    map['nutriScore'] = _nutriscore;

    map['quantity'] = _quantity;
    map['originCountry'] = _origin;
    map['manufactoringPlaces'] = _manufacturingPlaces;
    map['stores'] = _stores;

    return map;
  }

  static Future<Product> fromMap(Map<String, dynamic> data) async {
    int productId = data['id'];
    DateTime scanDate = DateTime.parse(data['scanDate']);
    Product product = Product(data['name'], data['imageUrl'], data['barcode'], scanDate, id: productId);

    int scanResultId = data['scanResultId'];
    product._scanResult = ScanResult.values.elementAt(scanResultId - 1);
    product._lastUpdated = DateTime.parse(data['lastUpdated']);
    product._nutriscore = data['nutriScore'];
    product._quantity = data['quantity'];
    product._origin = data['originCountry'];
    product._manufacturingPlaces = data['manufactoringPlaces'];
    product._stores = data['stores'];

    // TODO: when ingredient connections are in the database, then check if they can be read
    /*List<DbTable> ingredients = await DatabaseHelper.instance.readAll(DbTableNames.productIngredient, whereColumn: 'productId', whereArgs: [productId]);
    ingredients.forEach((element) {
      Ingredient ingredient = element as Ingredient;
      if(ingredient.type == Type.Nutriment) product.nutriments.add(element);
      else if(ingredient.type == Type.Allergen) product.allergens.add(element);
      else product.ingredients.add(ingredient);
    });*/

    return product;
  }
}