import '../databaseEntities/superClasses/DbList.dart';

import '../databaseEntities/Ingredient.dart';
import '../databaseEntities/Product.dart';
import '../databaseEntities/superClasses/DbTable.dart';

enum DbTableNames{
  ingredient,
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

  Future<DbTable> fromMap(Map<String, dynamic> data) async {
    switch(this){
      case DbTableNames.ingredient:
        return Ingredient.fromMap(data);
      case DbTableNames.product:
        return await Product.fromMap(data);
      case DbTableNames.list:
        return DbList.fromMap(data);
      default:
        return null;
    }
  }
}