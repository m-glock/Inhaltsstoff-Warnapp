import 'package:flutter/material.dart';

import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Enums/Type.dart';
import '../../preferences/PreferencesSummary.dart';
import './SettingsAllergenePreferences.dart';
import './SettingsNutrientPreferences.dart';
import './SettingsOtherIngredientPreferences.dart';

class SettingsPreferencesSummary extends StatefulWidget {
  SettingsPreferencesSummary({
    Key key,
  }) : super(key: key);

  @override
  _SettingsPreferencesSummaryState createState() =>
      _SettingsPreferencesSummaryState();
}

class _SettingsPreferencesSummaryState
    extends State<SettingsPreferencesSummary> {

  Map<Ingredient, PreferenceType> _allergenePreferences;
  Map<Ingredient, PreferenceType> _nutrientPreferences;
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
    _allergenePreferences = getIngredients(Type.Allergen);
    _nutrientPreferences = getIngredients(Type.Nutriment);
    _otherIngredientPreferences = getIngredients(Type.General);
  }

  @override
  Widget build(BuildContext context) {
    void _routeToSubPage(String pageName, BuildContext context) {
      switch (pageName) {
        case "allergens":
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => SettingsAllergenePreferences(
                onSave:
                    (Map<Ingredient, PreferenceType> newAllergenePreferences) {
                  setState(() {
                    PreferenceManager.changePreference(newAllergenePreferences);
                    _allergenePreferences = newAllergenePreferences;
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          );
          break;
        case "nutrients":
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  SettingsNutrientPreferences(onSave:
                    (Map<Ingredient, PreferenceType> newNutrientPreferences) {
                  setState(() {
                    PreferenceManager.changePreference(newNutrientPreferences);
                    _nutrientPreferences = newNutrientPreferences;
                    Navigator.pop(context);
                  });
                },)));
          break;
        case "unwantedIngredients":
        case "unpreferredIngredients":
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  SettingsOtherIngredientPreferences(onSave:
                    (Map<Ingredient, PreferenceType> newOtherIngredientPreferences) {
                  setState(() {
                    PreferenceManager.changePreference(newOtherIngredientPreferences);
                    _otherIngredientPreferences = newOtherIngredientPreferences;
                    Navigator.pop(context);
                  });
                },)));
          break;
        default:
          throw ('Illegal state: tried to navigate to sub page of SettingsPreferences but new Page ${pageName} does not exist');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Präferenzen'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        child: PreferencesSummary(
          allergenePreferences: _allergenePreferences,
          nutrientPreferences: _nutrientPreferences,
          otherIngredientPreferences: _otherIngredientPreferences,
          onEditPreference: (String newPageName) =>
              _routeToSubPage(newPageName, context),
        ),
      ),
    );
  }
}
