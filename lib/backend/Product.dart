import 'ScanResult.dart';

class Product{

  //TODO public getter, private setter
  String _name;
  ScanResult _scanResult;
  String _imageUrl;
  String _barcode;
  DateTime _scanDate;

  String _ingredients; //ingredients_text TODO enum or DB with possibilities, can be requested with https://de.openfoodfacts.org/data/taxonomies/ingredients.json
  Map<String, String> _nutriments; //nutrients
  List<String> _allergens; //ingredients_text_with_allergens_de, allergens_tags, allergens TODO as class/enum? Content ~40
  List<String> _vitamins; //vitamins_tags
  DateTime _lastUpdated; //last_modified_datetime
  String _traces; //traces_from_ingredients, traces
  String _nutriscore; //nutriscore_score (int), nutriscore_grade (char)
  List<String> _additives; //additives_tags TODO isVegan, isVegetarian, parent, additive_classes, can be requested by https://de.openfoodfacts.org/data/taxonomies/additives.json

  double _quantity; //quantity
  String _origin; //origins
  String _manufacturingPlaces; //manufacturing_places
  String _stores; //stores
  String _carbonFootprint; //TODO multiple ways to ask for this: per100g, serving size, percent


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