import '../database/DatabaseContainer.dart';
import '../database/DatabaseHelper.dart';
import '../enums/DbTableNames.dart';
import '../enums/ScanResult.dart';
import '../PreferenceManager.dart';
import './superClasses/DbTable.dart';
import './Ingredient.dart';

class Product extends DbTable {
  String name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime scanDate;
  DateTime _lastUpdated;
  String _nutriscore;

  List<Ingredient> ingredients;
  Map<Ingredient, ScanResult> _itemizedScanResults;
  List<Ingredient> _preferredIngredients;

  String _quantity;
  String _origin;
  String _manufacturingPlaces;
  String _stores;
  Future<void> scanResultPromise;
  Future<void> preferredIngredientsPromise;

  String get imageUrl => _imageUrl;

  String get barcode => _barcode;

  DateTime get lastUpdated => _lastUpdated;

  String get nutriscore => _nutriscore;

  String get quantity => _quantity;

  String get origin => _origin;

  String get manufacturingPlaces => _manufacturingPlaces;

  String get stores => _stores;

  void setName(String newName) {
    name = newName;
    DatabaseHelper.instance.update(this);
  }

  // async Getter and Setter for fields that are initialized asynchronously
  Future<ScanResult> getScanResult() async {
    if (_scanResult == null && scanResultPromise == null)
      scanResultPromise = initializeScanResult();
    if (scanResultPromise != null) await scanResultPromise;
    return _scanResult;
  }

  void setScanResult(ScanResult newResult) {
    _scanResult = newResult;
  }

  Future<Map<Ingredient, ScanResult>> getItemizedScanResults() async {
    if (_itemizedScanResults == null && scanResultPromise == null)
      scanResultPromise = initializeScanResult();
    if (scanResultPromise != null) await scanResultPromise;
    return _itemizedScanResults;
  }

  void setItemizedScanResults(Map<Ingredient, ScanResult> newResults) async {
    _itemizedScanResults = newResults;
    scanResultPromise = null;
  }

  Future<List<Ingredient>> getPreferredIngredients() async {
    if (_preferredIngredients == null && preferredIngredientsPromise == null)
      preferredIngredientsPromise = initializePreferredIngredients();
    if (preferredIngredientsPromise != null) await preferredIngredientsPromise;
    return _preferredIngredients;
  }

  void setPreferredIngredients(List<Ingredient> newIngredients) async {
    _preferredIngredients = newIngredients;
    preferredIngredientsPromise = null;
  }

  // simple constructor
  Product(this.name, this._imageUrl, this._barcode, this.scanDate, {int id})
      : super(id) {
    ingredients = List();
  }

  // full constructor
  Product.fullProduct(
      this.name,
      this._imageUrl,
      this._barcode,
      this.scanDate,
      this._lastUpdated,
      this._nutriscore,
      this._quantity,
      this._origin,
      this._manufacturingPlaces,
      this._stores,
      {int id})
      : super(id) {
    ingredients = List();
  }

  /*
  * Get the names of ingredients that are responsible for the overall scan result.
  * @param unwantedIngredients: determines whether to return the ingredients that cause a negative scan result (unwanted)
  *                             or those that are explicitly wanted by the user and contained in the product
  * @return: a list of ingredient names that are not wanted or those that are explicitly wanted
  * */
  Future<List<String>> getDecisiveIngredientNames(
      {bool getUnwantedIngredients = true}) async {
    if (getUnwantedIngredients) {
      List<String> ingredientsNames = List();
      Map<Ingredient, ScanResult> itemizedScanResults =
          await getItemizedScanResults();
      itemizedScanResults.entries.forEach((entry) {
        if (entry.value != ScanResult.Green)
          ingredientsNames.add(entry.key.name);
      });
      return ingredientsNames;
    } else {
      List<Ingredient> preferredIngredients = await getPreferredIngredients();
      return preferredIngredients.map((e) => e.name).toList();
    }
  }

  /*
  * Get the names of ingredients that are not preferenced by the user and are contained in the product.
  * @return: a list of ingredient names
  * */
  Future<List<String>> getNotPreferredIngredientNames() async {
    List<String> notPreferredIngredients = List();
    Map<Ingredient, ScanResult> itemizedScanResults =
        await getItemizedScanResults();
    List<Ingredient> unwantedPreferences = itemizedScanResults.keys.toList();
    List<Ingredient> preferredIngredients = await getPreferredIngredients();
    ingredients.forEach((element) {
      if (!unwantedPreferences.contains(element) &&
          !preferredIngredients.contains(element))
        notPreferredIngredients.add(element.name);
    });

    return notPreferredIngredients;
  }

  /*
  * Saves the product and all its relations in the database.
  * @return the new row id of the product
  * */
  Future<int> saveInDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;

    // add product to database
    int id = await helper.add(this);
    this.id = id;

    // save each ingredients connection to the product in productingredient
    if (ingredients.isNotEmpty) {
      for (Ingredient ingredient in ingredients) {
        if (ingredient.id == null) continue;
        Map<String, dynamic> values = Map();
        values['productId'] = this.id;
        values['ingredientId'] = ingredient.id;

        (await DatabaseContainer.instance.database)
            .insert(DbTableNames.productIngredient.name, values);
      }
    }

    return id;
  }

  /*
  * Set the scanResult for this product async because of the database access.
  * */
  Future<void> initializeScanResult() async {
    Map<Ingredient, ScanResult> itemizedScanResults =
        await PreferenceManager.getItemizedScanResults(this);
    setItemizedScanResults(itemizedScanResults);
  }

  /*
  * Set the preferred ingredients for this product async because of the database access.
  * */
  Future<void> initializePreferredIngredients() async {
    List<Ingredient> preferredIngredients =
        await PreferenceManager.getPreferredIngredientsIn(this);
    setPreferredIngredients(preferredIngredients);
  }

  // compare two products on the basis of their id
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Product && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  // Methods from super class
  @override
  String getTableName() {
    return DbTableNames.product.name;
  }

  @override
  Future<Map<String, dynamic>> toMap({bool withId = true}) async {
    final map = new Map<String, dynamic>();
    map['scanResultId'] = (await getScanResult()).id;
    map['name'] = name;
    map['imageUrl'] = _imageUrl;
    map['barcode'] = _barcode;
    map['scanDate'] = scanDate == null ? '' : scanDate.toIso8601String();
    map['lastUpdated'] =
        _lastUpdated == null ? '' : _lastUpdated.toIso8601String();
    map['nutriScore'] = _nutriscore;

    map['quantity'] = _quantity;
    map['originCountry'] = _origin;
    map['manufacturingPlaces'] = _manufacturingPlaces;
    map['stores'] = _stores;

    return map;
  }

  static Future<Product> fromMap(Map<String, dynamic> data) async {
    int productId = data['id'];
    String scanDateDb = data['scanDate'];
    DateTime scanDate = scanDateDb == ''
        ? null
        : DateTime.parse(data['scanDate']);

    Product product = Product(
        data['name'], data['imageUrl'], data['barcode'], scanDate,
        id: productId);

    int scanResultId = data['scanResultId'];
    product._scanResult = ScanResult.values.elementAt(scanResultId - 1);
    String lastUpdatedDb = data['lastUpdated'];
    product._lastUpdated = lastUpdatedDb == ''
        ? null
        : DateTime.parse(lastUpdatedDb);

    product._nutriscore = data['nutriScore'];
    product._quantity = data['quantity'];
    product._origin = data['originCountry'];
    product._manufacturingPlaces = data['manufacturingPlaces'];
    product._stores = data['stores'];

    // get all Ingredients associated with this product from the database
    List<DbTable> ingredients = await DatabaseHelper.instance.readAll(
        DbTableNames.productIngredient,
        'productId',
        [productId]);
    ingredients.forEach((element) {
      product.ingredients.add(element as Ingredient);
    });

    return product;
  }
}
