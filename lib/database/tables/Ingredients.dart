import 'IngredientGroup.dart';

class Ingredient{

  int _id;
  IngredientGroup _group;
  String _name;

  Ingredient(this._id, this._group, this._name);

  // Getter and Setter
  int get id => _id;

  IngredientGroup get group => _group;
  set group(IngredientGroup newGroup) => _group = newGroup;

  String get name => _name;

}