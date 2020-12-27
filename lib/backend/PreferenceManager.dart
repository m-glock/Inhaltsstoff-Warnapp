import 'dart:core';

import 'Enums/ScanResult.dart';
import 'Ingredient.dart';
import 'Enums/PreferenceType.dart';
import 'Enums/Type.dart';

import 'Product.dart';
import 'database/DbTableNames.dart';
import 'database/databaseHelper.dart';

class PreferenceManager {
  /*
  * When the user changes the preference of one or multiple Ingredients, this method is called and
  * saves the information in the database
  * @param preferenceChanges: a map of ingredients and the preference types they should change to
  * */
  static void changePreference(Map<Ingredient, PreferenceType> preferenceChanges) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;

    preferenceChanges.forEach((ingredient, preferenceType) async {
      //retrieve preferencetypeid and ingredient_id from the db
      var resultSetIngredient = await db.rawQuery(
          'select i.preferencetypeid as pr_id, i.id as ing_id from ingredient i join preferencetype p where i.name = ? and i.preferencetypeid=p.id',
          [ingredient.name]);
      var dbItem = resultSetIngredient.first;
      var preferenceTypeId = dbItem['pr_id'] as int;
      var ingrId = dbItem['ing_id'] as int;

      //retrieve id from the new preferenceType
      var resultSetPreferenceType = await db.rawQuery(
          'select id as pr_id from preferencetype where name = ?',
          [preferenceType.name]);
      var dbItem_1 = resultSetPreferenceType.first;
      var preferenceTypeIdNew = dbItem_1['pr_id'] as int;

      // update preferencetypeid in ingredient
      await db.rawUpdate(
          'UPDATE Ingredient SET preferencetypeid = ?, preferenceAddDate = ? WHERE id = ?',
          [preferenceTypeIdNew, Ingredient.getCurrentDate(), ingrId]);
    });
  }

  /*
  * get all Ingredients that are saved in the DB that have a preferenceType other than NONE
  * @param preferenceTypes: if only ingredients with a specific preference type are requested
  * @return: a list of all ingredients that the user has preferred
  * */
  static Future<List<Ingredient>> getPreferencedIngredients([List<PreferenceType> preferenceTypes]) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    List<Ingredient> ingredients = new List();

    if (preferenceTypes?.isEmpty ?? true) {
      List<Map> results = await db.rawQuery(
          "select i.name as ingredientName, p.name as preferenceName, i.preferenceAddDate, t.name TypeName, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where p.name is not 'None'");
      results.forEach((result) {
        //print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });
    }

    if (preferenceTypes?.isNotEmpty ?? true) {
      preferenceTypes.forEach((element) async {
        String element_name = element.name;
        //print(element_name);

        List<Map> results = await db.rawQuery(
            "select i.name as ingredientName, p.name as preferenceName, i.preferenceAddDate, t.name TypeName, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where p.name = ?",
            [element_name]);
        results.forEach((result) {
          print(result);
          Ingredient ingredient = Ingredient.fromMap(result);
          ingredients.add(ingredient);
        });
      });
    }

    return ingredients;
  }

  /*
  * Get all Ingredients from the DB independent of whether they have a set preference type or not
  * @param type: if only the ingredients of a specific type are relevant (i.e. vitamins, allergens)
  * @return: all Ingredients that are available in the database
  * */
  static Future<List<Ingredient>> getAllAvailableIngredients([Type type]) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    List<Ingredient> ingredients = new List();

    if (type == null) {
      List<Map> results = await db.rawQuery(
          "select i.name as ingredientName, p.name as preferenceName, i.preferenceAddDate, t.name TypeName, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id");
      results.forEach((result) {
        print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });
    }
    ;

    if (type != null) {
      String element_name = type.name;
      List<Map> results = await db.rawQuery(
          "select i.name as ingredientName, p.name as preferenceName, i.preferenceAddDate, t.name TypeName, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where t.name = ?",
          [element_name]);
      results.forEach((result) {
        print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });
    }

    return ingredients;

  }

  /*
  * Get all preferred ingredients and assign them a ScanResult on whether they are in the product or not.
  * Red = Ingredient is not wanted, but is contained in the product
  * Yellow = Ingredient is not preferred, but is contained in the product
  * Green = Ingredient is neither preferred or wanted, but is not contained in the product
  *
  * @param product: the product whose ingredient should be compared to the preferred ingredients
  * @return: a Map for each preferred Ingredient and its respective ScanResult to the product
  * */
  static Future<Map<Ingredient, ScanResult>> getItemizedScanResults(Product product) async {
    Map <Ingredient, ScanResult> itemizedScanResults = Map();
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;

    // red
    String productname = product.name;

    List<Map> results = await db.rawQuery(
        "select i.name as ingredientName, p.name as preferenceName, i.preferenceAddDate, t.name TypeName, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id join productingredient pi on i.id=pi.ingredientId join product pr on pr.id=pi.productId where pr.name = ?",[productname]);
    // CREATE TABLE ingredient ( id INTEGER PRIMARY KEY AUTOINCREMENT, preferenceTypeId INTEGER DEFAULT NULL, name TEXT NOT NULL, preferenceAddDate DATE DEFAULT NULL, typeId INTEGER NOT NULL, FOREIGN KEY(preferenceTypeId) REFERENCES preferencetype(id), FOREIGN KEY(typeId) REFERENCES type(id));
    // CREATE TABLE scanresult ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL );
    // CREATE TABLE list ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, parent INTEGER DEFAULT NULL, FOREIGN KEY(parent) REFERENCES list(id) );
    // CREATE TABLE product ( id INTEGER PRIMARY KEY AUTOINCREMENT, scanResultId INTEGER NOT NULL, name TEXT NOT NULL, imageUrl TEXT DEFAULT NULL, barcode TEXT NOT NULL, scanDate INTEGER NOT NULL, lastUpdated INTEGER DEFAULT NULL, nutriScore INTEGER DEFAULT NULL, quantity INTEGER DEFAULT NULL, originCountry TEXT DEFAULT NULL, manufactoringPlaces TEXT DEFAULT NULL, stores TEXT DEFAULT NULL, FOREIGN KEY(scanResultId) REFERENCES scanresult(id) );CREATE TABLE productlist ( listId INTEGER NOT NULL, productId INTEGER NOT NULL, FOREIGN KEY(listId) REFERENCES list(id), FOREIGN KEY(productId) REFERENCES product(id) );
    // CREATE TABLE productingredient ( productId INTEGER NOT NULL, ingredientId INTEGER NOT NULL,
    results.forEach((result) {
      print(result);
      Ingredient ingredient = Ingredient.fromMap(result);
      ScanResult scanresult = ScanResult.Red;

      //ingredients.add(ingredient);
    });


    return itemizedScanResults;
  }

    // yellow

    // green




      //retrieve id from the new preferenceType



    // itemizedScanResults[Ingredient('Zucker', PreferenceType.NotWanted, '')] = ScanResult.Red; //not wanted and in product
    // itemizedScanResults[Ingredient('Schokolade', PreferenceType.NotPreferred, '')] = ScanResult.Yellow; // not preferred and in product
    // itemizedScanResults[Ingredient('Magnesium', PreferenceType.NotPreferred, '')] = ScanResult.Green; //not preferred and not in product
    //itemizedScanResults[Ingredient('Wasser', PreferenceType.Preferred, '')] = ScanResult.Red; //preferred and not in product


}
