import 'ScanResult.dart';

class Product{

  String _name;
  ScanResult _scanResult;
  String _imageUrl; //TODO embed web image? maybe use Image class with multiple thumbnail image urls?
  String _barcode;
  DateTime _scanDate;

  String _ingredients;


  Product(this._name, this._scanResult, this._imageUrl, this._barcode, this._scanDate){
    //TODO which additional information do we need/want?
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    String name = json['product_name'];
    String imageUrl = json['image_url'];
    String barcode = json['code'];
    DateTime scanDate = DateTime.now();

    return Product(name, null, imageUrl, barcode, scanDate);
  }

}