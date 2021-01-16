import 'Enums/PreferenceType.dart';
import'Enums/Type.dart';
import 'Ingredient.dart';
import 'database/DbTableNames.dart';
import 'database/DatabaseHelper.dart';

class TextRecognitionParser{

  static final RegExp _patternStart = RegExp(r'[Zutaten]+:');
  static final RegExp _patternEnd = RegExp(r'\D\.');

  static Future<List<Ingredient>> parseIngredientNames(String text) async {
    String parsedText;

    // ingredients start with a specific word
    // everything before that is not needed
    if(text.contains(_patternStart)) parsedText = text.substring(text.indexOf(_patternStart) + 9);
    else parsedText = text;

    // dot normally marks the end of the ingredientslist
    // remove everything that comes after
    if(parsedText.contains(_patternEnd) || parsedText.endsWith('.')) {
      int index = parsedText.indexOf(_patternEnd);
      parsedText = parsedText.substring(0, index+1);
    }

    // remove percentages such as 25% or 7.4%
    // but do not remove other numbers such as in E150d
    parsedText = parsedText.replaceAll(RegExp(r'[0-9]+%|[0-9]+.[0-9]+%'), '');

    // remove any special character that might be in there
    parsedText = parsedText.replaceAll(RegExp(r'[&+=#|^\*%!]'), '');

    if(RegExp(r'\(\w+,').hasMatch(parsedText))
      parsedText = _handleParentheses(parsedText);

    // if text contains colon, then only the word after the colon
    // is considered an ingredient
    if(parsedText.contains(':'))
      parsedText = parsedText.replaceAll(RegExp(r'[a-zA-zöäüß]+: '), '');

    // spilt at either dot or semicolon
    List<String> ingredientNames = parsedText.split(RegExp(r', |; '));

    return null;
    //return await _getIngredientsFromText(ingredientNames);
  }


  /*
  * remove brackets and Word before brackets
  * inside the brackets are the actual ingredients while the word before that
  * is more like a product that consists of some ingredients
  * example: Weißbrot (WEIZENMEHL, Trinkwasser, Speisesalz, Hefe)
  * should not remove pattern such as Gelatine (Rind)
   */
  static String _handleParentheses(String text){
    // remove this kind of pattern and handle separately
    RegExp parenthesesPattern = RegExp(r'[a-zA-ZäöüÄÖÜß]+\s*?\(((?:\w+,\s)+\w+)\)');
    text = text.replaceAll(RegExp(r'\-'), '');
    String parenthesesText = parenthesesPattern.stringMatch(text);
    text = text.replaceAll(parenthesesPattern, '').trim();

    // remove left over commas
    if(text.endsWith(',')) text = text.substring(0, text.length - 1);
    else text = text.replaceAll(RegExp(r',\s*,'), ',');

    // remove word before parentheses and the closing parentheses
    parenthesesText = parenthesesText.replaceAll(RegExp(r'[a-zA-ZäöüÄÖÜß]+\s*?\(|\)'), '');

    // return original text with parsed text from parentheses
    return text + ', ' + parenthesesText;
  }

  static Future<List<Ingredient>> _getIngredientsFromText(List<String> ingredientNames) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Ingredient> ingredients = List();

    for(int i = 0; i <= ingredientNames.length; ++i){
      String name = ingredientNames.elementAt(i);
      Ingredient ing = await helper.read(DbTableNames.ingredient, [name], whereColumn: 'name'); //TODO cast as ingredient?
      if(ing == null){
        ing = Ingredient(name, PreferenceType.None, Type.General, null); //TODO Type general?
        await helper.add(ing);
      }
    }

    return ingredients;
  }
}