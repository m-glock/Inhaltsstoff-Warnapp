import 'package:Inhaltsstoff_Warnapp/database/tables/DbObject.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/IngredientGroup.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/Ingredients.dart';

enum DbTables{
  ingredient,
  ingredientType,
  type,
  preferenceType,
  productIngredient,
  scanResult,
  product,
  list,
  productList
}

extension DbTablesExtension on DbTables {

  String get name {
    switch (this) {
      case DbTables.ingredient:
        return 'ingredient';
      case DbTables.ingredientType:
        return 'ingredienttype';
      case DbTables.type:
        return 'type';
      case DbTables.preferenceType:
        return 'preferencetype';
      case DbTables.productIngredient:
        return 'productingredient';
      case DbTables.scanResult:
        return 'scanresult';
      case DbTables.product:
        return 'product';
      case DbTables.list:
        return 'list';
      case DbTables.productList:
        return 'productlist';
      default:
        return null;
    }
  }

  //TODO: add mapping for all classes
  DbObject fromMap(Map<String, dynamic> data){
    switch(this){
      case DbTables.ingredientType:
        return IngredientGroup.fromMap(data);
      case DbTables.ingredient:
        return Ingredient.fromMap(data);
      default:
        return null;
    }
  }
}