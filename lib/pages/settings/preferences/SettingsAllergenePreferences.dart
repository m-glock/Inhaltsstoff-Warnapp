import 'package:flutter/material.dart';

import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';
import '../../preferences/PreferencesAllergensView.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Enums/Type.dart';

class SettingsAllergenePreferences extends StatefulWidget {
  const SettingsAllergenePreferences({
    @required this.onSave,
  });

  final Function onSave;

  @override
  _SettingsAllergenePreferencesState createState() =>
      _SettingsAllergenePreferencesState();
}

class _SettingsAllergenePreferencesState
    extends State<SettingsAllergenePreferences> {

/*  Map<Ingredient, PreferenceType> _allergenePreferences;

  Map<Ingredient, PreferenceType> getIngredients(Type type) {
    Map<Ingredient, PreferenceType> ingredients = new Map();
    PreferenceManager.getAllAvailableIngredients(type)
        .then((value) => ingredients = Map.fromIterable(value
        .where((ingredient) => ingredient.type == type),
        key: (ingredient) => ingredient,
        value: (ingredient) => ingredient.preferenceType)
    );
    return ingredients;
  }*/
  Map<Ingredient, PreferenceType> _allergenePreferences;

  Future<Map<Ingredient, PreferenceType>> getIngredients(Type type) async {
    Map<Ingredient, PreferenceType> ingredients = new Map();
    var getAllAvailIg = await PreferenceManager.getAllAvailableIngredients(type);
    print(getAllAvailIg);
    ingredients = Map.fromIterable(getAllAvailIg
        .where((ingredient) => ingredient.type == type),
        key: (ingredient) => ingredient,
        value: (ingredient) => ingredient.preferenceType);
    return ingredients;
  }

  @override
  void initState() {
    super.initState();
    setIngredients();
  }

  void setIngredients() async {
    Map<Ingredient, PreferenceType> allergenePreferences = await getIngredients(Type.Allergen);
    setState(() {
      _allergenePreferences = allergenePreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergien'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => widget.onSave(_allergenePreferences),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PreferencesAllergensView(
          allergenePreferences: _allergenePreferences,
          onChange:
              (Ingredient changedIngredient, PreferenceType newPreference) {
            setState(() {
              _allergenePreferences[changedIngredient] = newPreference;
            });
          },
        ),
      ),
    );
  }
}
