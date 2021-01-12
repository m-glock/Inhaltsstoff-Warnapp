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
  static void changePreference(
      Map<Ingredient, PreferenceType> preferenceChanges) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;

    if (preferenceChanges?.isNotEmpty ?? true) {
      preferenceChanges.forEach((ingredient, preferenceType) async {
        //retrieve preferencetypeid and ingredient_id from the db
        List<Map> resultSetIngredient = await db.rawQuery(
            'select i.preferencetypeid as pr_id, i.id as ing_id from ingredient i join preferencetype p where i.name = ? and i.preferencetypeid=p.id',
            [ingredient.name]);
        // dynamic without var?
        var dbItem = resultSetIngredient.first;
        int preferenceTypeId = dbItem['pr_id'];
        int ingrId = dbItem['ing_id'];

        //retrieve id from the new preferenceType
        List<Map> resultSetPreferenceType = await db.rawQuery(
            'select id as pr_id from preferencetype where name = ?',
            [preferenceType.name]);
        // dynamic without var?
        var dbItem_1 = resultSetPreferenceType.first;
        int preferenceTypeIdNew = dbItem_1['pr_id'];

        // update preferencetypeid in ingredient
        await db.rawUpdate(
            'UPDATE Ingredient SET preferencetypeid = ?, preferenceAddDate = ? WHERE id = ?',
            [preferenceTypeIdNew, Ingredient.getCurrentDate(), ingrId]);

        //setter for the ingredient
        ingredient.changePreference(preferenceType);
      });
    }
  }
  /*
  * get all Ingredients that are saved in the DB that have a preferenceType other than NONE
  * @param preferenceTypes: if only ingredients with a specific preference type are requested
  * @return: a list of all ingredients that the user has preferred
  * */
  static Future<List<Ingredient>> getPreferencedIngredients(
      [List<PreferenceType> preferenceTypes]) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    List<Ingredient> ingredients = new List();

    if (preferenceTypes?.isEmpty ?? true) {
      List<Map> results = await db.rawQuery(
          "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where p.name is not 'None'");
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
            "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where p.name = ?",
            [element_name]);
        results.forEach((result) {
          //print(result);
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
          "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id limit 100");
      results.forEach((result) {
        //print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
      });
    }

    if (type != null) {
      String element_name = type.name;
      List<Map> results = await db.rawQuery(
          "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id where t.name = ? limit 100",
          [element_name]);
      results.forEach((result) {
        //print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ingredients.add(ingredient);
        //print(ingredients);
      });

    }

    return ingredients;

  }

  /*
  * TODO: after releasing the product class: test & improve the results -> discuss in team
  * Get all preferred ingredients and assign them a ScanResult on whether they are in the product or not.
  * Red = Ingredient is not wanted, but is contained in the product
  * Yellow = Ingredient is not preferred, but is contained in the product
  * Green = Ingredient is preferred or none and is contained in the product, or there is no match in the database
  *
  * @param product: the product whose ingredient should be compared to the preferred ingredients
  * @return: a Map for each preferred Ingredient and its respective ScanResult to the product
  * */
  static Future<Map<Ingredient, ScanResult>> getItemizedScanResults(
      Product product) async {
    Map<Ingredient, ScanResult> itemizedScanResults = Map();
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    String productname = product.name;
    String notwanted = 'Not Wanted';
    String notpreferred = 'Not Preferred';
    String preferred = 'Preferred';
    String none = 'None';

    // red
    List<Map> results_red = await db.rawQuery(
        "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id join productingredient pi on i.id=pi.ingredientId join product pr on pr.id=pi.productId where pr.name = ? and p.name = ?",
        [productname, notwanted]);
    if (results_red != null) {
      results_red.forEach((result) {
        //print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ScanResult scanresult = ScanResult.Red;
        itemizedScanResults.putIfAbsent(ingredient, () => scanresult);
      });
    }

    // yellow
    List<Map> results_yellow = await db.rawQuery(
        "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id join productingredient pi on i.id=pi.ingredientId join product pr on pr.id=pi.productId where pr.name = ? and p.name = ?",
        [productname, notpreferred]);
    if (results_yellow != null) {
      results_yellow.forEach((result) {
        //print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ScanResult scanresult = ScanResult.Yellow;
        itemizedScanResults.putIfAbsent(ingredient, () => scanresult);
      });
    }

    // green
    List<Map> results_green = await db.rawQuery(
        "select i.name as name, p.id as preferenceTypeId, t.id typeId, i.preferenceAddDate, i.id from ingredient i join preferencetype p on i.preferenceTypeId=p.id join type t on i.typeId=t.id join productingredient pi on i.id=pi.ingredientId join product pr on pr.id=pi.productId where pr.name = ? and (p.name = ? or p.name = ?)",
        [productname, preferred, none]);
    if (results_green != null) {
      results_green.forEach((result) {
        //print(result);
        Ingredient ingredient = Ingredient.fromMap(result);
        ScanResult scanresult = ScanResult.Green;
        itemizedScanResults.putIfAbsent(ingredient, () => scanresult);
      });
    }

    return itemizedScanResults;
  }

// itemizedScanResults[Ingredient('Zucker', PreferenceType.NotWanted, '')] = ScanResult.Red; //not wanted and in product
// itemizedScanResults[Ingredient('Schokolade', PreferenceType.NotPreferred, '')] = ScanResult.Yellow; // not preferred and in product
// itemizedScanResults[Ingredient('Magnesium', PreferenceType.NotPreferred, '')] = ScanResult.Green; //not preferred and not in product
//itemizedScanResults[Ingredient('Wasser', PreferenceType.Preferred, '')] = ScanResult.Red; //preferred and not in product

}