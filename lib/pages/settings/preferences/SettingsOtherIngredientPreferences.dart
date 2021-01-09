import 'package:flutter/material.dart';

import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';
import '../../preferences/PreferencesOtherIngredientsView.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Enums/Type.dart';

class SettingsOtherIngredientPreferences extends StatefulWidget {
  const SettingsOtherIngredientPreferences({
    @required this.onSave,
  });

  final Function onSave;

  @override
  _SettingsOtherIngredientPreferencesState createState() =>
      _SettingsOtherIngredientPreferencesState();
}

class _SettingsOtherIngredientPreferencesState
    extends State<SettingsOtherIngredientPreferences> {


  Map<Ingredient, PreferenceType> _otherIngredientPreferences;

  Map<Ingredient, PreferenceType> getIngredients(Type type) {
    Map<Ingredient, PreferenceType> ingredients = new Map();
    PreferenceManager.getAllAvailableIngredients(type)
        .then((value) => ingredients = Map.fromIterable(value
        .where((ingredient) => ingredient.type == type),
        key: (ingredient) => ingredient,
        value: (ingredient) => ingredient.preferenceType)
    );
    return ingredients;
  }

  @override
  void initState() {
    super.initState();
    _otherIngredientPreferences = getIngredients(Type.Allergen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unerwünschte Inhaltsstoffe'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => widget.onSave(_otherIngredientPreferences),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PreferencesOtherIngredientsView(
          otherIngredientPreferences: _otherIngredientPreferences,
          onChange:
              (Ingredient changedIngredient, PreferenceType newPreference) {
            setState(() {
              _otherIngredientPreferences[changedIngredient] = newPreference;
            });
          },
        ),
      ),
    );
  }
}
