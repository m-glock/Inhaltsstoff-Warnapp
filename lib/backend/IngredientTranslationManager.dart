import 'dart:collection';

import './FoodApiAccess.dart';

class IngredientTranslationManager{

  Map<String, dynamic> _allergens;
  Map<String, dynamic> _vitamins;
  Map<String, dynamic> _minerals;
  Map<String, dynamic> _ingredients;

  /*
  * Return the saved map of all possible values for a tag in the food API.
  * @param tag: the corresponding tag for the map to be accessed
  * @return a key-value json format of all values
  * */
  Future<Map<String, dynamic>> _getCorrespondingMap(String tag) async {
    // if the maps have not been initialized yet
    // get the corresponding maps from the food API first
    if(_allergens == null) _allergens =
        await FoodApiAccess.instance.getAllValuesForTag('allergens');
    if(_vitamins == null) _vitamins =
        await FoodApiAccess.instance.getAllValuesForTag('vitamins');
    if(_minerals == null) _minerals =
        await FoodApiAccess.instance.getAllValuesForTag('minerals');
    if(_ingredients == null) _ingredients =
        await FoodApiAccess.instance.getAllValuesForTag('ingredients');

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
  * Get the translated names of values for a key tag in a product json.
  * @param tag: the tag name from the product json
  * @param: tagValues: a list of specific values from this tag that should be translated
  * @param: languageCode: preferred language to translate the values into
  * @return a List of all possible values that exist in the API for this specific tag
  *         or null if tag was not found
  * */
  Future<List<String>> getTranslatedValuesForTag(
      String tag,
      {List<dynamic> tagValues,
      String languageCode:'de'}
  ) async {

    // get all possible values for this tag
    Map<dynamic, dynamic> allValues = await _getCorrespondingMap(tag);

    // either translate all values or just specific ones
    if(tagValues == null){
      return translateAllExistingValues(allValues, tag, languageCode);
    } else {
      return translateSpecificKeyValues(allValues, tagValues, tag, languageCode);
    }
  }

  /*
  * Translate all tag values from the food API for a specific tag key.
  * @param allTagValues: map of all tag values and their translations from the API
  * @param tag: the tag of the values to be translated (allergen, vitamin etc.)
  * @param languageCode: preferred language to translate the values into
  * @return a list of all translated value names
  * */
  List<String> translateAllExistingValues(
      Map<dynamic, dynamic> allTagValues,
      String tag,
      String languageCode
      ){
    List<String> translatedTagValues = new List();

    for(final keyValuePair in allTagValues.entries){

      // only use vitamins and minerals that are parents
      if((tag == 'vitamins' || tag == 'minerals')
          && keyValuePair.value['children'] == null)
        continue;

      // translate the value into the specified language or into english
      String tagValue = keyValuePair.value['name'][languageCode];
      if(tagValue == null){
        String tagValueEn = keyValuePair.value['name']['en'];
        tagValue = tagValueEn != null
            ? tagValueEn
            : keyValuePair.key;
      }

      // if it is still null because there was no translation
      // into the specified language or english found
      // use the untranslated value and remove the language code (fr:)
      if(tagValue != 'None'){
        tagValue = tagValue.substring(tagValue.indexOf(':') + 1);
        translatedTagValues.add(tagValue);
      }
    }

    return translatedTagValues;
  }

  /*
  * Translate a specified list of tag values from the food API for a specific tag key.
  * @param allTagValues: map of all tag values and their translations from the API
  * @param tagValues: list of specified tag values to be translated
  * @param tag: the tag of the values to be translated (allergen, vitamin etc.)
  * @param languageCode: preferred language to translate the values into
  * @return a list of all translated value names
  * */
  List<String> translateSpecificKeyValues(
      Map<dynamic, dynamic> allTagValues,
      List<dynamic> tagValues,
      String tag,
      String languageCode
  ){
    List<String> translatedTagValues = new List();

    tagValues.forEach((element) {
      String translatedName;
      if(allTagValues.containsKey(element)){
        LinkedHashMap tagValueTranslations = allTagValues[element]['name'];

        // get either the translation for the specified language
        // or the english translation
        if(languageCode == null){
          translatedName = tagValueTranslations['en'];
        } else {
          translatedName = tagValueTranslations.containsKey(languageCode)
              ? tagValueTranslations[languageCode]
              : tagValueTranslations['en'];
        }

        // if translatedName is still null, take the original name and
        // remove the language code and colon (i.e. 'fr:')
        if(translatedName == null){
          translatedName = element
              .substring(element.indexOf(':') + 1)
              .replaceAll('-', ' ');
        }
      } else {
        String name = element.toString();
        translatedName = name
            .substring(name.indexOf(':') + 1)
            .replaceAll('-', ' ');
      }
      translatedTagValues.add(translatedName);
    });

    return translatedTagValues;
  }
}