
import 'Enums/PreferenceType.dart';
import 'Enums/ScanResult.dart';
import 'Enums/Type.dart';
import 'FoodApiAccess.dart';
import 'Ingredient.dart';
import 'ListManager.dart';
import 'PreferenceManager.dart';
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

    // add Ingredients, Allergens, Vitamins, Additives and Traces
    FoodApiAccess foodApi = FoodApiAccess.instance;
    Set<String> translatedIngredientNames = Set();

    List<dynamic> allergenNames = json['allergens_tags'];
    if (allergenNames != null && allergenNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.translationManager
          .getTranslatedValuesForTag('allergens', tagValues: allergenNames));

    List<dynamic> vitaminNames = json['vitamins_tags'];
    if (vitaminNames != null && vitaminNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.translationManager
          .getTranslatedValuesForTag('vitamins', tagValues: vitaminNames));

    List<dynamic> mineralNames = json['minerals_tags'];
    if (mineralNames != null && mineralNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.translationManager
          .getTranslatedValuesForTag('minerals', tagValues: mineralNames));

    List<dynamic> ingredientNames = json['ingredients_tags'];

    if (ingredientNames != null && ingredientNames.isNotEmpty)
      translatedIngredientNames.addAll(await foodApi.translationManager
          .getTranslatedValuesForTag('ingredients', tagValues: ingredientNames));

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

    newProduct.scanResultPromise = initializeScanResult(newProduct);
    newProduct.preferredIngredientsPromise =
        initializePreferredIngredients(newProduct);

    return newProduct;
  }

  static Future<Product> fromTextRecognition(String ingredientsText, String productName) async {
    if(ingredientsText?.isEmpty ?? true) return null;

    List<Ingredient> ingredients = await TextRecognitionParser.parseIngredientNames(ingredientsText);
    Product product = Product(productName, null, null, DateTime.now());
    product.ingredients = ingredients;

    product.scanResultPromise = initializeScanResult(product);
    product.preferredIngredientsPromise =
        initializePreferredIngredients(product);

    await product.saveInDatabase();
    return product;
  }

  static Future<void> initializeScanResult(Product product) async {
    Map<Ingredient, ScanResult> itemizedScanResults =
    await PreferenceManager.getItemizedScanResults(product);
    product.setItemizedScanResults(itemizedScanResults);
  }

  static Future<void> initializePreferredIngredients(Product product) async {
    List<Ingredient> preferredIngredients =
    await PreferenceManager.getPreferredIngredientsIn(product);
    product.setPreferredIngredients(preferredIngredients);
  }
}