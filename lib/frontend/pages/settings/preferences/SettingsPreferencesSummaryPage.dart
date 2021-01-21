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
  Map<Ingredient, PreferenceType> _allergenePreferences = Map();
  Map<Ingredient, PreferenceType> _nutrientPreferences = Map();
  Map<Ingredient, PreferenceType> _otherIngredientPreferences = Map();

  @override
  void initState() {
    super.initState();
    setIngredients();
  }

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          children: [
            PreferencesSummary(
              allergenePreferences: _allergenePreferences,
              nutrientPreferences: _nutrientPreferences,
              otherIngredientPreferences: _otherIngredientPreferences,
              onEditPreference: (String newPageName) =>
                  _routeToSubPage(newPageName, context),
            ),
          ],
        ),
      ),
    );
  }

  void setIngredients() async {
    Map<Ingredient, PreferenceType> allergenePreferences =
        await getIngredients(Type.Allergen);
    Map<Ingredient, PreferenceType> nutrientPreferences =
        await getIngredients(Type.Nutriment);
    Map<Ingredient, PreferenceType> otherIngredientPreferences =
        await getIngredients(Type.General);
    setState(() {
      _allergenePreferences = allergenePreferences;
      _nutrientPreferences = nutrientPreferences;
      _otherIngredientPreferences = otherIngredientPreferences;
    });
  }

  Future<Map<Ingredient, PreferenceType>> getIngredients(Type type) async {
    List<Ingredient> getAllAvailIg =
        await PreferenceManager.getAllAvailableIngredients(type);
    return Map.fromIterable(
        getAllAvailIg.where((ingredient) => ingredient.type == type),
        key: (ingredient) => ingredient,
        value: (ingredient) => ingredient.preferenceType);
  }

  void _routeToSubPage(String pageName, BuildContext context) {
    switch (pageName) {
      case "allergens":
        Navigator.of(context).pushNamed(
          '/settings/preferences/allergenes',
          arguments: (Map<Ingredient, PreferenceType> newAllergenePreferences) {
            setState(() {
              PreferenceManager.changePreference(newAllergenePreferences);
              _allergenePreferences = newAllergenePreferences;
              Navigator.pop(context);
            });
          },
        );
        break;
      case "nutrients":
        Navigator.of(context).pushNamed(
          '/settings/preferences/nutrients',
          arguments: (Map<Ingredient, PreferenceType> newNutrientPreferences) {
            setState(() {
              PreferenceManager.changePreference(newNutrientPreferences);
              _nutrientPreferences = newNutrientPreferences;
              Navigator.pop(context);
            });
          },
        );
        break;
      case "unwantedIngredients":
      case "unpreferredIngredients":
        Navigator.of(context).pushNamed(
          '/settings/preferences/otherIngredients',
          arguments:
              (Map<Ingredient, PreferenceType> newOtherIngredientPreferences) {
            setState(() {
              PreferenceManager.changePreference(newOtherIngredientPreferences);
              _otherIngredientPreferences = newOtherIngredientPreferences;
              Navigator.pop(context);
            });
          },
        );
        break;
      default:
        throw ('Illegal state: tried to navigate to sub page of SettingsPreferences but new Page ${pageName} does not exist');
    }
  }
}
