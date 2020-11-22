import 'ScanResult.dart';

class Product{

  String _name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime _scanDate;

  String _ingredients; //ingredients_text TODO enum or DB with possibilities, can be requested with https://de.openfoodfacts.org/data/taxonomies/ingredients.json
  Map<String, String> _nutriments; //nutrients
  Map<String, String> _allergens; //ingredients_text_with_allergens_de, allergens_tags, allergens
  List<String> _vitamins; //vitamins_tags
  DateTime _lastUpdated; //last_modified_datetime
  String _traces; //traces_from_ingredients, traces
  String _nutriscore; //nutriscore_score (int), nutriscore_grade (char)
  List<String> _additives; //additives_tags TODO isVegan, isVegetarian, parent, additive_classes, can be requested by https://de.openfoodfacts.org/data/taxonomies/additives.json

  double _quantity; //quantity
  String _origin; //origins
  String _manufacturingPlaces; //manufacturing_places
  String _stores; //stores

  // Getter
  String get name => _name;
  ScanResult get scanResult => _scanResult;
  String get imageUrl => _imageUrl;
  String get barcode => _barcode;
  DateTime get scanDate => _scanDate;

  String get ingredients => _ingredients;
  Map<String, String> get nutriments => _nutriments;
  Map<String, String> get allergens => _allergens;
  List<String> get vitamins => _vitamins;
  DateTime get lastUpdated => _lastUpdated;
  String get traces => _traces;
  String get nutriscore => _nutriscore;
  List<String> get additives => _additives;

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
    //TODO add other important stuff from json

    return newProduct;
  }

}