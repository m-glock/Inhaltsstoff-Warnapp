import 'package:Essbar/backend/IngredientTranslationManager.dart';

import './ListManager.dart';
import 'Lists/History.dart';
import 'database/DbTableNames.dart';
import 'database/DatabaseHelper.dart';
import 'database/DbTable.dart';
import 'Product.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'ProductFactory.dart';

class FoodApiAccess{

  final String _foodDbApiUrl = 'https://de-de.openfoodfacts.org';
  final String _taxonomyEndpoint = 'data/taxonomies';
  final String _productEndpoint = 'api/v0/product';
  final IngredientTranslationManager _translationManager = IngredientTranslationManager();

  IngredientTranslationManager get translationManager => _translationManager;

  // make this a singleton class
  FoodApiAccess._privateConstructor();
  static final FoodApiAccess instance = FoodApiAccess._privateConstructor();

  /*
  * sends an GET request to the food database API with the scanned barcode and
  * creates a Product object containing the relevant information
  * @param barcode: the scanned barcode from a product
  * @return: an object for the scanned product with the relevant information
  *           or null if not found
  * */
  Future<Product> scanProduct(String barcode) async{
    Product product = await checkForProductInDb(barcode);
    if(product != null) return product;

    String requestUrl = '$_foodDbApiUrl/$_productEndpoint/$barcode.json';
    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check HTTP status
    if (status == 404) return null;
    else if(status != 200) throw HttpException('$status');

    // handle if product does not exist in the food API database
    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson =
        json.decode(utf8.decode(response.bodyBytes));

    if(decodedJson['status'] == 0){
      log('Product with Barcode $barcode does not exist in the database.');
      return null;
    }

    // transform json data into a product object and save it in database
    product = await ProductFactory.fromApiJson(decodedJson['product']);
    product.id = await product.saveInDatabase();

    // save product in history
    History history = await ListManager.instance.history;
    history.addProduct(product);

    return product;
  }

  Future<Product> checkForProductInDb(String barcode) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    History history = await ListManager.instance.history;

    DbTable table = await helper.read(
        DbTableNames.product,
        [barcode],
        whereColumn: 'barcode');

    if(table != null){
      Product productFromDb = table as Product;
      productFromDb.scanDate = DateTime.now();
      productFromDb.scanResultPromise =
          ProductFactory.initializeScanResult(productFromDb);
      productFromDb.preferredIngredientsPromise =
          ProductFactory.initializePreferredIngredients(productFromDb);

      await helper.update(productFromDb);
      history.addProduct(productFromDb);

      return productFromDb;
    }

    return null;
  }


  /*
  * get the json of all possible values of a tag
  * @param tag: the tag name from the product json
  * @return a map of all possible values that exist in the API
  *         for this specific tag or null if tag was not found
  * */
  Future<Map<dynamic, dynamic>> getAllValuesForTag(String tag) async {
    String requestUrl = '$_foodDbApiUrl/$_taxonomyEndpoint/$tag.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check HTTP status
    if (status == 404) return null;
    else if(status != 200) throw HttpException('$status');

    // utf8 decoding for umlaute
    // if requested tag does not exist, the response body will be html
    // and the decoding will return null
    Map<String, dynamic> decodedJson =
    json.decode(utf8.decode(response.bodyBytes));
    if(decodedJson == null) throw HttpException('404');

    return decodedJson;
  }

  /*
  * builds a GET request
  * @param url: the url to send the request to
  * @return: the http response that the GET call returned
  * */
  Future<http.Response> _getRequest(String url) {
    return http.get(
        url,
        headers: <String, String>{
          'User-Agent': 'Essbar - Android - Version 1.0',
        },
    );
  }

}