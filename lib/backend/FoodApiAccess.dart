import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'Enums/PreferenceType.dart';
import 'Ingredient.dart';
import 'Product.dart';
import 'package:http/http.dart' as http;

class FoodApiAccess{

  final String _foodDbApiUrl = 'https://de-de.openfoodfacts.org';
  final String _taxonomyEndpoint = 'data/taxonomies';
  final String _productEndpoint = 'api/v0/product';
  Map _allergens;
  Map _vitamins;
  Map _ingredients;

  // make this a singleton class
  FoodApiAccess._privateConstructor(){
      _setAllergens();
      _setVitamins();
      //_setIngredients();
  }

  static final FoodApiAccess instance = FoodApiAccess._privateConstructor();

  void _setAllergens() async => _allergens = await getAllValuesForTag('allergens');
  void _setVitamins() async => _vitamins = await getAllValuesForTag('vitamins');
  //void _setIngredients() async => _ingredients = await getAllValuesForTag('ingredients');

  Map<dynamic, dynamic> _getCorresponsingMap(String tag){
    switch(tag){
      case 'vitamins':
        return _vitamins;
      case 'allergens':
        return _allergens;
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

    // create Product object
    return Product.fromApiJson(decodedJson['product']);
  }

  /*
  * get the json of all possible values of a tag
  * @param tag: the tag name from the product json
  * @return a map of all possible values that exist in the API for this specific tag or null if tag was not found
  * */
  Future<Map<dynamic, dynamic>> getAllValuesForTag(String tag, {String languageCode:'de'}) async {
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
    Map<dynamic, dynamic> allTagValues = _getCorresponsingMap(tag);

    if(tagValues == null || tagValues.isEmpty){ // translate all existing tag values

      allTagValues.forEach((key, value) {
        String tagValue = value['name'][languageCode];
        if(tagValue == null) tagValue = value['name']['en'];
        translatedTagValues.add(tagValue);
      });

    } else { // translate only tag names in tagValues

      tagValues.forEach((element) {
        String translatedName;
        if(allTagValues.containsKey(element)){
          LinkedHashMap tagValueTranslations = allTagValues[element]['name'];
          translatedName = tagValueTranslations.containsKey(languageCode) ? tagValueTranslations[languageCode] : tagValueTranslations['en'];
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
  * TODO: get existing Ingredient from DB instead of creating a new Ingredient object every time
  * translates all tag names of a list from the Food API and then gets the corresponding ingredient from the DB.
  * Names normally start with language code such as en: or de:
  * @param ingredientNames: List of all ingredient names to be translated
  * @param tag: Tag that the names belong to (allergens, vitamins, ingredients etc.)
  * @return: a List of ingredient
  * */
  Future<List<Ingredient>> getIngredientsWithTranslatedNames(List<dynamic> ingredientNames, String tag) async {
    List<Ingredient> ingredients = List();
    List<String> translatedIngredientNames = await getTranslatedValuesForTag(tag, tagValues: ingredientNames);
    translatedIngredientNames.forEach(
            (element) => ingredients.add(Ingredient(element, PreferenceType.None, ''))
    );
    return ingredients;
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
          'User-Agent': 'Unknown - Android - Version 1.0', //TODO: add name of App
        },
    );
  }

}