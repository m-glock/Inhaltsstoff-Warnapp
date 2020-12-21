import 'package:flutter/material.dart';

import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Enums/Type.dart';
import '../../PreferencesSummary.dart';
import './SettingsAllergenePreferences.dart';
import './SettingsNutrientPreferences.dart';
import './SettingsOtherIngredientPreferences.dart';

class SettingsPreferencesSummary extends StatelessWidget {
  SettingsPreferencesSummary({
    Key key,
  }) : super(key: key);

  final Map<Ingredient, PreferenceType> _allergenePreferences =
      Map.fromIterable(
          PreferenceManager.getAllAvailableIngredients(type: Type.Allergen)
              .where((ingredient) => ingredient.type == Type.Allergen),
          key: (ingredient) => ingredient,
          value: (ingredient) => ingredient.preferenceType);

  final Map<Ingredient, PreferenceType> _nutrientPreferences = Map.fromIterable(
      PreferenceManager.getAllAvailableIngredients(type: Type.Nutriment)
          .where((ingredient) => ingredient.type == Type.Nutriment),
      key: (ingredient) => ingredient,
      value: (ingredient) => ingredient.preferenceType);

  final Map<Ingredient, PreferenceType> _otherIngredientPreferences =
      Map.fromIterable(
          PreferenceManager.getAllAvailableIngredients(type: Type.General)
              .where((ingredient) => ingredient.type == Type.General),
          key: (ingredient) => ingredient,
          value: (ingredient) => ingredient.preferenceType);

  void _routeToSubPage(String pageName, BuildContext context) {
    switch (pageName) {
      case "allergens":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SettingsAllergenePreferences()));
        break;
      case "nutrients":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SettingsNutrientPreferences()));
        break;
      case "unwantedIngredients":
      case "unpreferredIngredients":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                SettingsOtherIngredientPreferences()));
        break;
      default:
        throw ('Illegal state: tried to navigate to sub page of SettingsPreferences but new Page ${pageName} does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Präferenzen'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: PreferencesSummary(
        allergenePreferences: _allergenePreferences,
        nutrientPreferences: _nutrientPreferences,
        otherIngredientPreferences: _otherIngredientPreferences,
        onEditPreference: (String newPageName) =>
            _routeToSubPage(newPageName, context),
      ),
    );
  }
}
