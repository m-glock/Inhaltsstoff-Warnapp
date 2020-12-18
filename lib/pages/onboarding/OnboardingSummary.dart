import 'package:flutter/material.dart';

import '../../backend/Ingredient.dart';
import '../../backend/Enums/PreferenceType.dart';

class OnboardingSummary extends StatelessWidget {
  OnboardingSummary(
      {this.allergenePreferences,
      this.nutrientPreferences,
      this.otherIngredientPreferences,
      this.onEditPreference});

  final Map<Ingredient, PreferenceType> allergenePreferences;
  final Map<Ingredient, PreferenceType> nutrientPreferences;
  final Map<Ingredient, PreferenceType> otherIngredientPreferences;
  final Function onEditPreference;

  Map<String, List<String>> get _allPreferences {
    Map<String, List<String>> preferencesMap = {
      "allergens": [],
      "nutrients": [],
      "unwantedIngredientsNothing": [],
      "unwantedIngredientsFew": []
    };
    allergenePreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.NotWanted)
        preferencesMap["allergens"].add(ingredient.name);
    });
    nutrientPreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.Preferred)
        preferencesMap["nutrients"].add(ingredient.name);
    });
    otherIngredientPreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.NotWanted)
        preferencesMap["unwantedIngredientsNothing"].add(ingredient.name);
      else if (preference == PreferenceType.NotPreferred)
        preferencesMap["unwantedIngredientsFew"].add(ingredient.name);
    });
    return preferencesMap;
  }

  final Map<String, Map> _preferenceCategoryInfo = {
    "allergens": {
      "icon": Icons.medical_services_outlined,
      "title": "Allergien",
    },
    "nutrients": {
      "icon": Icons.insights,
      "title": "Erwünschte Nährstoffe",
    },
    "unwantedIngredientsNothing": {
      "icon": Icons.remove_circle_outline,
      "title": "Verbotene Inhaltsstoffe",
    },
    "unwantedIngredientsFew": {
      "icon": Icons.trending_down,
      "title": "Zu reduzierende Inhaltsstoffe",
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          _allPreferences.length,
          (keyIndex) {
            String key = _allPreferences.keys.elementAt(keyIndex);
            print("key:" + key);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    _preferenceCategoryInfo[key]["icon"],
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    _preferenceCategoryInfo[key]["title"],
                    style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[900],
                    ),
                    onPressed: () => onEditPreference(key),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  height: 8.0,
                ),
                if (_allPreferences[key].length > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Wrap(
                      spacing: 12.0,
                      runSpacing: 0.0,
                      children: List<Widget>.generate(
                        _allPreferences[key].length,
                        (int valueIndex) {
                          return Chip(
                            backgroundColor: Colors.grey[200],
                            label: Text(_allPreferences[key][valueIndex]),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                if (_allPreferences[key].length > 0)
                  Divider(
                    thickness: 1.0,
                    height: 8.0,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
