import 'package:Inhaltsstoff_Warnapp/database/tables/DbObject.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/IngredientGroup.dart';
import 'package:Inhaltsstoff_Warnapp/database/tables/Ingredients.dart';

enum DbTables{
  ingredients,
  ingredientGroup,
}

extension DbTablesExtension on DbTables {

  String get name {
    switch (this) {
      case DbTables.ingredientGroup:
        return 'Ingredient_group';
      case DbTables.ingredients:
        return 'Ingredients';
      default:
        return null;
    }
  }

  DbObject fromMap(Map<String, dynamic> data){
    switch(this){
      case DbTables.ingredientGroup:
        return IngredientGroup.fromMap(data);
      case DbTables.ingredients:
        return Ingredient.fromMap(data);
      default:
        return null;
    }
  }
}