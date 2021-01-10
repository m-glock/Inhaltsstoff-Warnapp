import 'package:flutter/material.dart';

import '../../../../backend/Enums/PreferenceType.dart';
import '../../../../backend/Ingredient.dart';
import '../../../../backend/PreferenceManager.dart';
import '../../../../backend/Enums/Type.dart';
import '../../../customWidgets/preferences/PreferencesSummary.dart';
import './SettingsAllergenePreferencesPage.dart';
import './SettingsNutrientPreferencesPage.dart';
import './SettingsOtherIngredientPreferencesPage.dart';

class SettingsPreferencesSummaryPage extends StatefulWidget {
  SettingsPreferencesSummaryPage({
    Key key,
  }) : super(key: key);

  @override
  _SettingsPreferencesSummaryPageState createState() =>
      _SettingsPreferencesSummaryPageState();
}

class _SettingsPreferencesSummaryPageState
    extends State<SettingsPreferencesSummaryPage> {
  Map<Ingredient, PreferenceType> _allergenePreferences = Map.fromIterable(
      PreferenceManager.getAllAvailableIngredients(type: Type.Allergen)
          .where((ingredient) => ingredient.type == Type.Allergen),
      key: (ingredient) => ingredient,
      value: (ingredient) => ingredient.preferenceType);

  Map<Ingredient, PreferenceType> _nutrientPreferences = Map.fromIterable(
      PreferenceManager.getAllAvailableIngredients(type: Type.Nutriment)
          .where((ingredient) => ingredient.type == Type.Nutriment),
      key: (ingredient) => ingredient,
      value: (ingredient) => ingredient.preferenceType);

  Map<Ingredient, PreferenceType> _otherIngredientPreferences =
      Map.fromIterable(
          PreferenceManager.getAllAvailableIngredients(type: Type.General)
              .where((ingredient) => ingredient.type == Type.General),
          key: (ingredient) => ingredient,
          value: (ingredient) => ingredient.preferenceType);

  @override
  Widget build(BuildContext context) {
    void _routeToSubPage(String pageName, BuildContext context) {
      switch (pageName) {
        case "allergens":
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => SettingsAllergenePreferencesPage(
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
                  SettingsNutrientPreferencesPage(onSave:
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
                  SettingsOtherIngredientPreferencesPage(onSave:
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
