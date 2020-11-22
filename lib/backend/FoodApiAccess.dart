import 'dart:convert';
import 'dart:developer';

import 'Product.dart';
import 'package:http/http.dart' as http;

class FoodApiAccess{

  static final String _foodDbApiUrl = 'https://de-de.openfoodfacts.org';
  static final String _taxonomyEndpoint = 'data/taxonomies';
  static final String _productEndpoint = 'api/v0/product';

  /*
  * sends an GET request to the food database API with the scanned barcode and creates a Product object containing the relevant information
  * @param barcode: the scanned barcode from a product
  * @return: an object for the scanned product with the relevant information
  * */
  static Future<Product> scanProduct(String barcode) async{
    String requestUrl = '$_foodDbApiUrl/$_productEndpoint/$barcode.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check if API returned a valid response
    // TODO: better handling than just throwing exceptions?
    if(status == 502 || status == 503 || status == 500) throw Exception('Open Food Facts API Server is down.');
    else if(status != 200) return null;

    // handle if product does not exist in the food API database
    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    if(decodedJson['status'] == '0'){
      log('Product with Barcode $barcode does not exist in the database.');
      return null;
    }

    // create Product object
    return Product.fromJson(decodedJson['product']);
  }

  /*
  * sends a GET request to the food database API to get all possible values for a tag in a product json
  * @param tag: the tag name from the product json
  * @return a List of all possible values that exist in the API for this specific tag
  * */
  static Future<List<String>> getValuesForTag(String tag) async {
    String requestUrl = '$_foodDbApiUrl/$_taxonomyEndpoint/$tag.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    //TODO: error handling for wrong status: body is html instead of json when searching for something that does not exist
    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    List<String> possibleValuesForTag = new List();

    // if requested tag does not exist, the response body will be html and the decoding will reutrn null
    if(status == 502 || status == 503 || status == 500) throw Exception('Open Food Facts API Server is down.');
    else if(status == 404) return null;

    decodedJson.forEach((key, value) {
      String tagValue = value['name']['de'];
      if(tagValue == null) tagValue = value['name']['en'];
      possibleValuesForTag.add(tagValue);
    });

    return possibleValuesForTag;
  }

  /*
  * sends a GET request to the food database API to get the translation of a certain tag value
  * @param tag: the tag from the product json that the value to translate belongs to
  * @param tagValue: the name of the value to translate
  * @param languageCode: the ISO 639-1 language code for the target language
  * @return the translation of the tag Value according to the API
  * */
  static Future<List<String>> translateTagNames(String tag, List<dynamic> tagValues, {String languageCode:'de'}) async {
    String requestUrl = '$_foodDbApiUrl/$_taxonomyEndpoint/$tag.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    //TODO: error handling for wrong status: body is html instead of json when searching for something that does not exist
    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    List<String> translatedTagValues = List();

    // if requested tag does not exist, the response body will be html and the decoding will reutrn null
    if(status == 502 || status == 503 || status == 500) throw Exception('Open Food Facts API Server is down.');
    else if(status == 404) return null;

    tagValues.forEach((element) {
      String translatedName;
      if(decodedJson.containsKey(element)){
        var tagValueTranslations = decodedJson[element]['name'];
        translatedName = tagValueTranslations[languageCode] != null ? tagValueTranslations[languageCode] : tagValueTranslations['en'];
      } else {
        String name = element.toString();
        translatedName = name.substring(name.indexOf(':') + 1);
      }

      translatedTagValues.add(translatedName);
    });

    return translatedTagValues;
  }

  /*
  * builds a GET request
  * @param url: the url to send the request to
  * @return: the http response that the GET call returned
  * */
  static Future<http.Response> _getRequest(String url) {
    return http.get(
        url,
        headers: <String, String>{
          'User-Agent': 'Unknown - Android - Version 1.0', //TODO: add name of App
        },
    );
  }

}