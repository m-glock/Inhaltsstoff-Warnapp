import 'package:Inhaltsstoff_Warnapp/backend/Enums/PreferenceType.dart';
import 'package:Inhaltsstoff_Warnapp/backend/PreferenceManager.dart';
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

  // Setter
  set name(String newName) => _name = newName;
  set scanDate(DateTime newTime) => _scanDate = newTime;
  set scanResult(ScanResult newResult) => _scanResult = newResult;

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
    int dateTime = json['last_modified_t'] * 1000;
    newProduct._lastUpdated = DateTime.fromMillisecondsSinceEpoch(dateTime);
    newProduct._nutriscore = json['nutriscore_grade'];

    newProduct._quantity = json['quantity'];
    newProduct._origin = json['origins'];
    newProduct._manufacturingPlaces = json['manufacturing_places'];
    newProduct._stores = json['stores'];

    // add Ingredients, Allergens, Vitamins, Additives and Traces
    FoodApiAccess foodApi = FoodApiAccess.instance;
    Set<String> translatedIngredientNames = Set();

    List<dynamic> allergenNames = json['allergens_tags'];
    if(allergenNames != null && allergenNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('allergens', tagValues: allergenNames));

    List<dynamic> vitaminNames = json['vitamins_tags'];
    if(vitaminNames != null && vitaminNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('vitamins', tagValues: vitaminNames));

    List<dynamic> mineralNames = json['minerals_tags'];
    if(mineralNames != null && mineralNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('minerals', tagValues: mineralNames));

    List<dynamic> ingredientNames = json['ingredients_tags'];
    if(ingredientNames != null && ingredientNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.getTranslatedValuesForTag('ingredients', tagValues: ingredientNames));

    for(String name in translatedIngredientNames) {
      newProduct._ingredients.add(await DatabaseHelper.instance.read(DbTableNames.ingredient, [name], whereColumn: 'name'));
    }

    PreferenceManager.getItemizedScanResults(newProduct);

    return newProduct;
  }

  /*
  TODO: move to preferenceManager
  * get the names of ingredients that are responsible for the overall scan result.
  * Either return the names of responsible ingredients that are not wanted or those that are explicitly wanted
  * @param unwantedIngredients: determines whether to return the ingredients that cause a negative scan result (unwanted)
  *                             or those that are explicitly wanted by the user and contained in the product
  * @return: a list of ingredient names
  * */
  List<String> getDecisiveIngredientNames(bool getUnwantedIngredients){
    if(getUnwantedIngredients){
      Map<Ingredient, ScanResult> itemizedScanResult;
      PreferenceManager.getItemizedScanResults(this).then((value) => itemizedScanResult = value);
      itemizedScanResult.removeWhere((key, value) => value == ScanResult.Green);
      return itemizedScanResult.keys.toList().map((ingredient) => ingredient.name);
    } else {
      List<String> preferredIngredientNames = List();
      List<PreferenceType> options = [PreferenceType.Preferred];
      List<Ingredient> preferredIngredients;
      PreferenceManager.getPreferencedIngredients(options).then((value) => preferredIngredients = value);

      preferredIngredients.forEach((ingredient) {
        if(_ingredients.contains(ingredient))
          preferredIngredientNames.add(ingredient.name);
      });

      return preferredIngredientNames;
    }
  }

  /*
  * get the names of ingredients that are not preferenced by the user and are contained in the product.
  * @return: a list of ingredient names
  * TODO: move to preferenceManager
  * */
  List<String> getNotPreferredIngredientNames(){
    List<String> notPreferredIngredientNames = List();
    List<PreferenceType> options = [PreferenceType.Preferred, PreferenceType.NotWanted, PreferenceType.NotPreferred];
    List<Ingredient> preferredIngredients;
    PreferenceManager.getPreferencedIngredients(options).then((value) => preferredIngredients = value);

    preferredIngredients.forEach((ingredient) {
      if(_ingredients.contains(ingredient))
        notPreferredIngredientNames.add(ingredient.name);
    });

    return notPreferredIngredientNames;
  }

  Future<int> saveInDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;

    // add product to database
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

    // get all Ingredients associated with this product from the database
    List<DbTable> ingredients = await DatabaseHelper.instance.readAll(DbTableNames.productIngredient, whereColumn: 'productId', whereArgs: [productId]);
    ingredients.forEach((element) {
      product.ingredients.add(element as Ingredient);
    });

    return product;
  }
}