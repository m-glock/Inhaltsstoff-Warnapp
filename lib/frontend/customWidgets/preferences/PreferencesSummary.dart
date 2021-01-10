import 'package:flutter/material.dart';

import '../../../backend/Ingredient.dart';
import '../../../backend/Enums/PreferenceType.dart';
import '../../../customWidgets/EditableChipsList.dart';

class PreferencesSummary extends StatelessWidget {
  PreferencesSummary({
    this.allergenePreferences,
    this.nutrientPreferences,
    this.otherIngredientPreferences,
    this.onEditPreference,
  });

  final Map<Ingredient, PreferenceType> allergenePreferences;
  final Map<Ingredient, PreferenceType> nutrientPreferences;
  final Map<Ingredient, PreferenceType> otherIngredientPreferences;
  final Function onEditPreference;

  List<String> get _nutrients {
    List<String> ingredientNames = [];
    nutrientPreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.Preferred)
        ingredientNames.add(ingredient.name);
    });
    return ingredientNames;
  }

  List<String> get _allergens {
    List<String> ingredientNames = [];
    allergenePreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.NotWanted)
        ingredientNames.add(ingredient.name);
    });
    return ingredientNames;
  }

  List<String> get _unWantedOtherIngredients {
    List<String> ingredientNames = [];
    otherIngredientPreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.NotWanted)
        ingredientNames.add(ingredient.name);
    });
    return ingredientNames;
  }

  List<String> get _unPreferredOtherIngredients {
    List<String> ingredientNames = [];
    otherIngredientPreferences.forEach((ingredient, preference) {
      if (preference == PreferenceType.NotPreferred)
        ingredientNames.add(ingredient.name);
    });
    return ingredientNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          EditableChipsList(
            icon: Icons.medical_services_outlined,
            title: "Allergien",
            items: _allergens,
            onEdit: () {
              onEditPreference("allergens");
            },
          ),
          EditableChipsList(
            icon: Icons.insights,
            title: "Erwünschte Nährstoffe",
            items: _nutrients,
            onEdit: () {
              onEditPreference("nutrients");
            },
          ),
          EditableChipsList(
            icon: Icons.remove_circle_outline,
            title: "Verbotene Inhaltsstoffe",
            items: _unWantedOtherIngredients,
            onEdit: () {
              onEditPreference("unwantedIngredients");
            },
          ),
          EditableChipsList(
            icon: Icons.trending_down,
            title: "Zu reduzierende Inhaltsstoffe",
            items: _unPreferredOtherIngredients,
            onEdit: () {
              onEditPreference("unpreferredIngredients");
            },
          )
        ],
      ),
    );
  }
}
