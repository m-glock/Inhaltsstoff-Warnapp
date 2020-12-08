import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'Ingredient.dart';
import 'Product.dart';
import 'Type.dart';
import 'package:http/http.dart' as http;

class FoodApiAccess{

  static final String _foodDbApiUrl = 'https://de-de.openfoodfacts.org';
  static final String _taxonomyEndpoint = 'data/taxonomies';
  static final String _productEndpoint = 'api/v0/product';

  /*
  * sends an GET request to the food database API with the scanned barcode and creates a Product object containing the relevant information
  * @param barcode: the scanned barcode from a product
  * @return: an object for the scanned product with the relevant information or null if not found
  * */
  static Future<Product> scanProduct(String barcode) async{
    String requestUrl = '$_foodDbApiUrl/$_productEndpoint/$barcode.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check HTTP status
    if (status == 404) return null;
    else if(status != 200) throw HttpException('$status');

    // handle if product does not exist in the food API database
    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    if(decodedJson['status'] == '0'){
      log('Product with Barcode $barcode does not exist in the database.');
      return null;
    }

    // create Product object
    return Product.fromApiJson(decodedJson['product']);
  }

  /*
  * sends a GET request to the food database API to get all possible values for a tag in a product json
  * @param tag: the tag name from the product json
  * @return a List of all possible values that exist in the API for this specific tag or null if tag was not found
  * */
  static Future<List<String>> getAllValuesForTag(String tag, {String languageCode:'de'}) async {
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
    List<String> possibleValuesForTag = new List();

    decodedJson.forEach((key, value) {
      String tagValue = value['name'][languageCode];
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
  * @return the translation of the tag Value according to the API or null if tag was not found
  * */
  static Future<List<String>> _translateTagNames(String tag, List<String> tagValues, {String languageCode:'de'}) async {
    String requestUrl = '$_foodDbApiUrl/$_taxonomyEndpoint/$tag.json';

    http.Response response = await _getRequest(requestUrl);
    int status = response.statusCode;

    // check HTTP status
    if (status == 404) return null;
    else if(status != 200) throw HttpException('$status');

    // utf8 decoding for umlaute
    Map<String, dynamic> decodedJson = json.decode(utf8.decode(response.bodyBytes));
    List<String> translatedTagValues = List();

    tagValues.forEach((element) {
      String translatedName;
      if(decodedJson.containsKey(element)){
        LinkedHashMap tagValueTranslations = decodedJson[element]['name'];
        translatedName = tagValueTranslations.containsKey(languageCode) ? tagValueTranslations[languageCode] : tagValueTranslations['en'];
      } else {
        String name = element.toString();
        translatedName = name.substring(name.indexOf(':') + 1);
      }

      translatedTagValues.add(translatedName);
    });

    return translatedTagValues;
  }

  /*
  * TODO: get existing Ingredient from DB instead of creating a new Ingredient object every time
  * translates all tag names of a list from the Food API and then gets the corresponding ingredient from the DB.
  * Names normally start with language code such as en: or de:
  * @param ingredientNames: List of all ingredient names to be translated
  * @param tag: Tag that the names belong to (allergens, vitamins, ingredients etc.)
  * @return: a List of ingredient
  * */
  static Future<List<Ingredient>> getIngredientsWithTranslatedNames(List<String> ingredientNames, String tag) async {
    List<Ingredient> ingredients = List();
    List<String> translatedIngredientNames = await _translateTagNames(tag, ingredientNames);
    translatedIngredientNames.forEach((element) => ingredients.add(Ingredient(element, Type.Nutriment)));
    return ingredients;
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