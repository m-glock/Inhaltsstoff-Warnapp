import '../Ingredient.dart';
import 'DbTable.dart';

enum DbTableNames{
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

extension DbTablesExtension on DbTableNames {

  String get name {
    switch (this) {
      case DbTableNames.ingredient:
        return 'ingredient';
      case DbTableNames.ingredientType:
        return 'ingredienttype';
      case DbTableNames.type:
        return 'type';
      case DbTableNames.preferenceType:
        return 'preferencetype';
      case DbTableNames.productIngredient:
        return 'productingredient';
      case DbTableNames.scanResult:
        return 'scanresult';
      case DbTableNames.product:
        return 'product';
      case DbTableNames.list:
        return 'list';
      case DbTableNames.productList:
        return 'productlist';
      default:
        return null;
    }
  }

  //TODO: add mapping for all classes
  DbTable fromMap(Map<String, dynamic> data){
    switch(this){
      case DbTableNames.ingredient:
        return Ingredient.fromMap(data);
      default:
        return null;
    }
  }
}