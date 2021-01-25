
import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';
import 'FoodApiAccess.dart';
import 'Ingredient.dart';
import 'Product.dart';
import 'TextRecognitionParser.dart';
import 'database/DatabaseHelper.dart';
import 'database/DbTableNames.dart';

class ProductFactory{

  /*
  * Uses the json from the Food API to create a new Product object
  * @param json: the json that the food API returns for a barcode
  * @return: a new Product object
  * */
  static Future<Product> fromApiJson(Map<String, dynamic> json) async {
    // read and save content directly from json
    String name = json['product_name'];
    String imageUrl = json['image_url'];
    String barcode = json['code'];
    DateTime scanDate = DateTime.now();

    int dateTime = json['last_modified_t'] * 1000;
    DateTime lastUpdated = DateTime.fromMillisecondsSinceEpoch(dateTime);
    String nutriscore = json['nutriscore_grade'];

    String quantity = json['quantity'];
    String origin = json['origins'];
    String manufacturingPlaces = json['manufacturing_places'];
    String stores = json['stores'];

    Product newProduct = Product.fullProduct(name, imageUrl, barcode, scanDate,
        lastUpdated, nutriscore, quantity, origin, manufacturingPlaces, stores);

    // translate Ingredients, Allergens and Vitamins
    Set<String> translatedIngredientNames = Set();
    translatedIngredientNames.addAll(await translateIngredients(json['allergens_tags'], 'allergens'));
    translatedIngredientNames.addAll(await translateIngredients(json['vitamins_tags'], 'vitamins'));
    translatedIngredientNames.addAll(await translateIngredients(json['minerals_tags'], 'minerals'));
    translatedIngredientNames.addAll(await translateIngredients(json['ingredients_tags'], 'ingredients'));

    // get Ingredient objects for translated names
    // either from the database or by creating a new one
    for (String name in translatedIngredientNames) {
      Ingredient ingredient = await DatabaseHelper.instance
          .read(DbTableNames.ingredient, [name], whereColumn: 'name');
      if (ingredient == null) {
        ingredient = new Ingredient(name, PreferenceType.None, Type.General, null);
        int id = await DatabaseHelper.instance.add(ingredient);
        ingredient.id = id;
      }
      newProduct.ingredients.add(ingredient);
    }

    // evaluate the scan result
    newProduct.scanResultPromise = newProduct.initializeScanResult();
    newProduct.preferredIngredientsPromise =
        newProduct.initializePreferredIngredients();

    return newProduct;
  }

  /*
  * Uses the text from the text recognition to create a new Product object
  * @param ingredientsText: the text from the text recognition
  * @return: a new Product object
  * */
  static Future<Product> fromTextRecognition(String ingredientsText) async {
    if(ingredientsText?.isEmpty ?? true) return null;

    // parse ingredients from text and create a product onbject
    List<Ingredient> ingredients = await TextRecognitionParser.parseIngredientNames(ingredientsText);
    Product product = Product('', null, null, DateTime.now());
    product.ingredients = ingredients;

    // evaluate the scan result
    product.scanResultPromise = product.initializeScanResult();
    product.preferredIngredientsPromise =
        product.initializePreferredIngredients();

    // save and return product
    int id = await product.saveInDatabase();
    product.id = id;
    return product;
  }

  /*
  * Translate ingredientNames into a specific language.
  * @param ingredientNames: all ingredient names that should be translated
  * @return a list of translated ingredient names
  * */
  static Future<List<String>> translateIngredients(List<dynamic> ingredientNames, String tag) async {
    if(ingredientNames == null || ingredientNames.isEmpty) return new List<String>();

    return await FoodApiAccess.instance.translationManager
        .getTranslatedValuesForTag(tag, tagValues: ingredientNames);
  }
}