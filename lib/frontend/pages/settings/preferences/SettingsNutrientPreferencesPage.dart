import 'package:flutter/material.dart';

import '../../../../backend/Enums/PreferenceType.dart';
import '../../../../backend/Ingredient.dart';
import '../../../../backend/PreferenceManager.dart';
import '../../../../backend/Enums/Type.dart';
import '../../../customWidgets/preferences/PreferencesNutrientsView.dart';

class SettingsNutrientPreferencesPage extends StatefulWidget {
  const SettingsNutrientPreferencesPage({
    @required this.onSave,
  });

  final Function onSave;

  @override
  _SettingsNutrientPreferencesPageState createState() =>
      _SettingsNutrientPreferencesPageState();
}

class _SettingsNutrientPreferencesPageState
    extends State<SettingsNutrientPreferencesPage> {
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
