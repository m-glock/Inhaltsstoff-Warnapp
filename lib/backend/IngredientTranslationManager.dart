
import 'dart:collection';

import 'package:Essbar/backend/FoodApiAccess.dart';

class IngredientTranslationManager{

  Map _allergens;
  Map _vitamins;
  Map _minerals;
  Map _ingredients;

  Future<Map> _getCorrespondingMap(String tag) async {
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
  * get the translated names of values for a tag in a product json
  * @param tag: the tag name from the product json
  * @param: tagValues: a list of specific values from this tag that should be translated
  * @param: languageCode: code for the target language of the translation
  * @return a List of all possible values that exist in the API for this specific tag
  *         or null if tag was not found
  * */
  Future<List<String>> getTranslatedValuesForTag(
      String tag,
      {List<dynamic> tagValues,
        String languageCode:'de'}
      ) async {
    Map<dynamic, dynamic> allTagValues = await _getCorrespondingMap(tag);

    if(tagValues == null){
      return translateAllExistingValues(allTagValues, tag, languageCode);
    } else {
      return translateSpecificTagNames(allTagValues, tagValues, tag, languageCode);
    }

  }

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

    return translatedTagValues;
  }

  List<String> translateSpecificTagNames(
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