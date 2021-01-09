import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'database/DbTableNames.dart';
import 'database/databaseHelper.dart';
import 'database/DbTable.dart';
import 'Product.dart';

class FoodApiAccess{

  final String _foodDbApiUrl = 'https://de-de.openfoodfacts.org';
  final String _taxonomyEndpoint = 'data/taxonomies';
  final String _productEndpoint = 'api/v0/product';
  Map _allergens;
  Map _vitamins;
  Map _minerals;
  Map _ingredients;

  // make this a singleton class
  FoodApiAccess._privateConstructor();
  static final FoodApiAccess instance = FoodApiAccess._privateConstructor();

  Future<Map> _getCorrespondingMap(String tag) async {
    if(_allergens == null) _allergens = await _getAllValuesForTag('allergens');
    if(_vitamins == null) _vitamins = await _getAllValuesForTag('vitamins');
    if(_minerals == null) _minerals = await _getAllValuesForTag('minerals');
    if(_ingredients == null) _ingredients = await _getAllValuesForTag('ingredients');

    switch(tag){
      case 'vitamins':
        return _vitamins;
      case 'allergens':
        return _allergens;
      case 'minerals':
        return _minerals;
      case 'ingredients':
        return _ingredients;
      default:
        return null;
    }
  }

  /*
  * sends an GET request to the food database API with the scanned barcode and creates a Product object containing the relevant information
  * @param barcode: the scanned barcode from a product
  * @return: an object for the scanned product with the relevant information or null if not found
  * */
  Future<Product> scanProduct(String barcode) async{
    DatabaseHelper helper = DatabaseHelper.instance;

    // if Product has already been scanned before, return data from DB
    DbTable table = await helper.read(DbTableNames.product, [barcode], whereColumn: 'barcode');
    if(table != null){
      Product productFromDb = table as Product;
      productFromDb.scanDate = DateTime.now();

      String tableName = productFromDb.getTableName().name;
      String newScanDate = productFromDb.scanDate.toIso8601String();
      int productId = productFromDb.id;
      await helper.customQuery('UPDATE $tableName SET scanDate = $newScanDate WHERE id = $productId');
      return productFromDb;
    }

    String requestUrl = '$_foodDbApiUrl/$_productEndpoint/$barcode.json';
    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check HTTP status
    if (status == 404) return null;
    else if(status != 200) throw HttpException('$status');

    // handle if product does not exist in the food API database
    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    if(decodedJson['status'] == 0){
      log('Product with Barcode $barcode does not exist in the database.');
      return null;
    }

    // transform json data into a product object
    Product product = await Product.fromApiJson(decodedJson['product']);

    // save product in database
    await product.saveInDatabase();

    return product;
  }

  /*
  * get the json of all possible values of a tag
  * @param tag: the tag name from the product json
  * @return a map of all possible values that exist in the API for this specific tag or null if tag was not found
  * */
  Future<Map<dynamic, dynamic>> _getAllValuesForTag(String tag) async {
    String requestUrl = '$_foodDbApiUrl/$_taxonomyEndpoint/$tag.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check HTTP status
    if (status == 404) return null;
    else if(status != 200) throw HttpException('$status');

    // utf8 decoding for umlaute
    // if requested tag does not exist, the response body will be html and the decoding will return null
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    if(decodedJson == null) throw HttpException('404');

    return decodedJson;
  }

  /*
  * get the translated names of all possible values for a tag in a product json
  * @param tag: the tag name from the product json
  * @param: tagValues: a list of specific values from this tag that should be translated
  * @param: languageCode: code for that target language of the translation
  * @return a List of all possible values that exist in the API for this specific tag or null if tag was not found
  * */
  Future<List<String>> getTranslatedValuesForTag(String tag, {List<dynamic> tagValues, String languageCode:'de'}) async {
    List<String> translatedTagValues = new List();
    Map<dynamic, dynamic> allTagValues = await _getCorrespondingMap(tag);

    if(tagValues == null){ // translate all existing tag values

      for(final keyValuePair in allTagValues.entries){
        // only use vitamins and minerals that are parents
        if((tag == 'vitamins' || tag == 'minerals') && keyValuePair.value['children'] == null)
          continue;

        String tagValue = keyValuePair.value['name'][languageCode];
        if(tagValue == null){
          String tagValueEn = keyValuePair.value['name']['en'];
          tagValue = tagValueEn != null
              ? tagValueEn
              : keyValuePair.key;
        }

        if(tagValue != 'None'){
          tagValue = tagValue.substring(tagValue.indexOf(':') + 1);
          translatedTagValues.add(tagValue);
        }
      }

    } else { // translate only tag names in tagValues

      tagValues.forEach((element) {
        String translatedName;
        if(allTagValues.containsKey(element)){
          LinkedHashMap tagValueTranslations = allTagValues[element]['name'];
          translatedName = tagValueTranslations.containsKey(languageCode)
              ? tagValueTranslations[languageCode]
              : tagValueTranslations['en'];
        } else {
          String name = element.toString();
          translatedName = name.substring(name.indexOf(':') + 1);
        }
        translatedTagValues.add(translatedName);
      });
    }

    return translatedTagValues;
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