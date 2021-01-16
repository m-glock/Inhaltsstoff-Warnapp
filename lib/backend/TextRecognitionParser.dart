
import 'Enums/PreferenceType.dart';
import'Enums/Type.dart';
import 'Ingredient.dart';
import 'database/DbTableNames.dart';
import 'database/DatabaseHelper.dart';

class TextRecognitionParser{

  static Future<List<Ingredient>> parseIngredientNames(String text) async {
    //
    String parsedText;
    String pattern = 'Zutaten: ';
    if(text.contains(pattern)) parsedText = text.substring(text.indexOf(pattern) + pattern.length);
    else parsedText = text;

    parsedText = parsedText.replaceAll(RegExp(r'[0-9]+%|[0-9]+.[0-9]+%|\.'), '');
    if(parsedText.contains(RegExp(r'( & ) '))){
      int indexOfBracket = parsedText.indexOf(RegExp(r'[] ('));
    }
    List<String> ingredientNames = parsedText.split(RegExp(r', |; '));

    String text3 = 'Zutaten: 76% Butter, 7% Zwiebeln, 6% Petersilie, Wasser, '
        '3% Knoblauch, 1,8% Speisesalz, 1% Schnittlauch, 1% Kräuter (Dill, Zwiebellauch, Basilikum), '
        'Gewürze, natürliches Aroma, Säuerungsmittel: Citronensäure';


    // if contains (), then take elements from () separately
    // remove ,name () before ()

    for(int i = 0; i < ingredientNames.length; ++i){
      String element = ingredientNames.elementAt(i);
      if(element.contains(':')) {
        ingredientNames.remove(element);
        ingredientNames.add(element.substring(element.indexOf(':') + 2));
        i -= 1;
      }
    }

    return null;
    //return await _getIngredientsFromText(ingredientNames);
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