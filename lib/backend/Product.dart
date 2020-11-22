import 'package:Inhaltsstoff_Warnapp/backend/FoodApiAccess.dart';

import 'ScanResult.dart';

class Product{

  String _name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime _scanDate;

  List<dynamic>  _ingredients;
  Map<String, dynamic> _nutriments;
  List<dynamic> _allergens;
  List<dynamic> _vitamins;
  DateTime _lastUpdated;
  List<dynamic> _traces;
  String _nutriscore;
  List<dynamic> _additives;

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

  List<dynamic> get ingredients => _ingredients;
  Map<String, dynamic> get nutriments => _nutriments;
  List<dynamic> get allergens => _allergens;
  List<dynamic> get vitamins => _vitamins;
  DateTime get lastUpdated => _lastUpdated;
  List<dynamic> get traces => _traces;
  String get nutriscore => _nutriscore;
  List<dynamic> get additives => _additives;

  double get quantity => _quantity;
  String get origin => _origin;
  String get manufacturingPlaces => _manufacturingPlaces;
  String get stores => _stores;


  // constructor with minimal necessary information
  Product(this._name, this._scanResult, this._imageUrl, this._barcode, this._scanDate);

  factory Product.fromJson(Map<String, dynamic> json) {
    String name = json['product_name'];
    String imageUrl = json['image_url'];
    String barcode = json['code'];
    DateTime scanDate = DateTime.now();

    Product newProduct = Product(name, null, imageUrl, barcode, scanDate);

    // TODO: handle that not all information is in german.
    // ingredients -> ingredients.json for ingredients_tags
    // allergens -> allergens.json for allergens_tags
    // vitamins -> vitamins.json for vitamins_tags
    // traces -> allergens.json for tranes_tags
    // additives -> additives.json for additives_tags
    newProduct._ingredients = json['ingredients_tags'];
    newProduct._nutriments = json['nutriments'];
    newProduct._allergens = json['allergens_tags'];
    newProduct._vitamins = json['vitamins_tags'];
    var dateTime = json['last_modified_t'] * 1000;
    newProduct._lastUpdated = DateTime.fromMillisecondsSinceEpoch(dateTime);
    newProduct._traces = json['traces_tags'];
    newProduct._nutriscore = json['nutriscore_grade']; //nutriscore_score (int)
    newProduct._additives = json['additives_tags'];

    String quantityString = (json['quantity'] as String).trim().replaceAll(new RegExp('[a-zA-Z]'), '');
    newProduct._quantity = double.parse(quantityString);
    newProduct._origin = json['origins'];
    newProduct._manufacturingPlaces = json['manufacturing_places'];
    newProduct._stores = json['stores'];

    return newProduct;
  }

}