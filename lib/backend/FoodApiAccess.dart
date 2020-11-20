import 'dart:convert';
import 'dart:developer';

import 'Product.dart';
import 'package:http/http.dart' as http;

class FoodApiAccess{

  static final String _apiUrl = 'https://de-de.openfoodfacts.org';
  static final String _taxonomyEndpoint = 'data/taxonomies';
  static final String _productEndpoint = 'api/v0/product';


  static Future<Product> scanProduct(String barcode) async{
    String requestUrl = '$_apiUrl/$_productEndpoint/$barcode.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check if API returned a valid response
    // TODO: better handling than just throwing exceptions? Just return null?
    if(status == 502 || status == 503 || status == 500) throw Exception('Open Food Facts API Server is down.');
    else if(status != 200) throw Exception('Failed to access Open Food Facts API');

    // handle if product does not exist in the food API database
    Map<String, dynamic> decodedJson = jsonDecode(response.body);
    if(decodedJson['status'] == '0'){
      log('Product with Barcode $barcode does not exist in the database.');
      return null;
    }

    // create Product object
    return Product.fromJson(decodedJson);
  }

  static List<String> getContentForTag(String tag){
    // TODO how to make sure tag is something that is in the api?
    String request = '$_apiUrl/$_taxonomyEndpoint/$tag.json';
  }

  static Future<http.Response> _getRequest(String url) {
    return http.get(
        url,
        headers: <String, String>{
          'User-Agent': 'Unknown - Android - Version 1.0', //TODO: add name of App
        },
    );
  }


}