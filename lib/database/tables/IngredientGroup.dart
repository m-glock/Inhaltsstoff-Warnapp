
class IngredientGroup{

  int _id;
  String _name;

  IngredientGroup(this._id, this._name);

  // Getter and Setter
  int get id => _id;
  String get name => _name;
  static String get tableName => 'Ingredient_Group';
}