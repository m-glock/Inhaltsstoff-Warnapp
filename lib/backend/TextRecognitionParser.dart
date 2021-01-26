import './database/DatabaseHelper.dart';
import './databaseEntities/Ingredient.dart';
import './enums/PreferenceType.dart';
import './enums/Type.dart';

class TextRecognitionParser {
  static final RegExp _patternStart = RegExp(r'[ten]+:');
  static final RegExp _patternEnd = RegExp(r'\D\.');
  static final List<String> _additiveNames = [
    'Säuerungsmittel',
    'Verdickungsmittel',
    'Emulgatoren',
    'Emulgator',
    'Stabilisatoren',
    'Stabilisator',
    'Farbstoffe',
    'Farbstoff',
    'Geschmacksverstärker',
    'Konservierungsstoffe',
    'Konservierungsstoff'
  ];

  /*
  * Parse an ingredient text and remove unnecessary words, characters and numbers,
  * so that it leaves only the ingredient names which can be searched in the database
  * @param text: ingredient text to parse
  * @return a list of ingredient names
  * */
  static Future<List<String>> parseIngredientNames(String text) async {
    String parsedText;

    // ingredients start with a specific word
    // everything before that is not needed
    if (text.contains(_patternStart))
      parsedText = text.trim().substring(text.indexOf(_patternStart) + 4);
    else
      parsedText = text.trim();

    // dot normally marks the end of the ingredients list
    // remove everything that comes after
    if (parsedText.contains(_patternEnd)) {
      int index = parsedText.indexOf(_patternEnd);
      parsedText = parsedText.substring(0, index + 1);
    } else if (parsedText.endsWith('.')) {
      parsedText = parsedText.substring(0, parsedText.length - 1);
    }

    // remove percentages such as 25% or 7.4%
    // but do not remove other numbers such as in E150d
    parsedText = parsedText.replaceAll(RegExp(r'[0-9]+%|[0-9]+.[0-9]+%'), '');

    // if text contains any of the additive labels, then remove those
    // so that only the name of the additive ingredient is left
    _additiveNames.forEach((element) {
      if (parsedText.contains(element))
        parsedText = parsedText.replaceAll(element, '');
    });

    // remove any special character that might be in there
    parsedText = parsedText.replaceAll(RegExp(r'[&+=#|^\*%!:\-\"]'), '');

    // handle parentheses
    if (RegExp(r'\(\w+,').hasMatch(parsedText))
      parsedText = _handleParentheses(parsedText);

    // spilt at either dot or semicolon
    List<String> ingredientNames = parsedText.split(RegExp(r',|;'));

    return ingredientNames.map((e) => e.trim()).toList();
  }

  /*
  * Transform a text of ingredients from the text recognition
  * into a list of ingredients for the product
  * @param text: ingredient text to parse
  * @return a list of ingredient objects that have been parsed from the text
  * */
  static Future<List<Ingredient>> getIngredientsFromText(String text) async {
    List<String> parsedIngredientNames = await parseIngredientNames(text);
    return await _getIngredientsForParsedText(parsedIngredientNames);
  }

  /*
  * Handle parentheses and possible ingredients inside.
  * should split pattern 'Weißbrot (WEIZENMEHL, Trinkwasser, Speisesalz, Hefe)'
  * into WEIZENMEHL, Trinkwasser, Speisesalz, Hefe (without Weißbrot)
  * should not split/remove pattern such as Gelatine (Rind)
  * @param text: ingredient text to parse
  * @return the old string of ingredients with the split parentheses text
  *         added at the end
   */
  static String _handleParentheses(String text) {
    // remove this kind of pattern and handle separately
    RegExp parenthesesPattern =
        RegExp(r'[a-zA-ZäöüÄÖÜß]+\s*?\(((?:\w+,\s*)+\w+)\)');
    String newText = text;
    newText = newText.replaceAll(RegExp(r'\-'), '');

    // find pattern in text and extract it
    String parenthesesText = parenthesesPattern.stringMatch(newText);
    newText = newText.replaceAll(parenthesesPattern, '').trim();

    // remove left over commas
    if (newText.endsWith(','))
      newText = newText.substring(0, newText.length - 1);
    else
      newText = newText.replaceAll(RegExp(r',\s*,'), ',');

    // remove word before parentheses and the closing parentheses
    if (parenthesesText != null) {
      parenthesesText =
          parenthesesText.replaceAll(RegExp(r'[a-zA-ZäöüÄÖÜß]+\s*?\(|\)'), '');

      // return original text with parsed text from parentheses
      return newText + ', ' + parenthesesText;
    } else {
      return text;
    }
  }

  /*
  * Transform a list of ingredient names into a list of ingredient objects.
  * @param ingredientNames: a list of ingredient names
  * @return a list of ingredient objects either from the database if found
  *         or new ones if not
  * */
  static Future<List<Ingredient>> _getIngredientsForParsedText(
      List<String> ingredientNames) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Ingredient> ingredients = List();

    for (int i = 0; i <= ingredientNames.length - 1; ++i) {
      String name = ingredientNames.elementAt(i).trim().toLowerCase();

      // search for ingredient in database
      List<Map<String, dynamic>> data = await helper
          .customQuery('SELECT * FROM ingredient WHERE name LIKE \'$name\'');
      Ingredient ing = (data != null && data.isNotEmpty)
          ? Ingredient.fromMap(data[0])
          : null;

      // if no match was found in the database, create a new object
      if (ing == null) {
        ing = Ingredient(ingredientNames.elementAt(i).trim(),
            PreferenceType.None, Type.General, null);
      }
      ingredients.add(ing);
    }

    return ingredients;
  }
}
