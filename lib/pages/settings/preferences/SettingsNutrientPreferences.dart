import 'package:flutter/material.dart';

import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';
import '../../preferences/PreferencesNutrientsView.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Enums/Type.dart';

class SettingsNutrientPreferences extends StatefulWidget {
  const SettingsNutrientPreferences({
    @required this.onSave,
  });

  final Function onSave;

  @override
  _SettingsNutrientPreferencesState createState() =>
      _SettingsNutrientPreferencesState();
}

class _SettingsNutrientPreferencesState
    extends State<SettingsNutrientPreferences> {
  Map<Ingredient, PreferenceType> _nutrientPreferences = Map.fromIterable(
      PreferenceManager.getAllAvailableIngredients(type: Type.Nutriment)
          .where((ingredient) => ingredient.type == Type.Nutriment),
      key: (ingredient) => ingredient,
      value: (ingredient) => ingredient.preferenceType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Erwünschte Nährstoffe'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => widget.onSave(_nutrientPreferences),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PreferencesNutrientsView(
          nutrientPreferences: _nutrientPreferences,
          onChange:
              (Ingredient changedIngredient, PreferenceType newPreference) {
            setState(() {
              _nutrientPreferences[changedIngredient] = newPreference;
            });
          },
        ),
      ),
    );
  }
}