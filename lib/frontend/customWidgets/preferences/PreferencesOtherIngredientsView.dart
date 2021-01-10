import 'package:flutter/material.dart';

import '../RadioButtonTable.dart';
import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';

class PreferencesOtherIngredientsView extends StatelessWidget {
  PreferencesOtherIngredientsView({
    this.otherIngredientPreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> otherIngredientPreferences;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    // TODO: render Search Bar
    return RadioButtonTable(
      items:
          otherIngredientPreferences.map((ingredient, preference) => MapEntry(
              ingredient.name,
              preference == PreferenceType.None
                  ? "egal"
                  : preference == PreferenceType.NotWanted
                      ? "nichts"
                      : "wenig")),
      options: ["nichts", "egal", "wenig"],
      onChange: (int index, String newPreferenceValue) {
        Ingredient changedIngredient =
            otherIngredientPreferences.keys.toList()[index];
        PreferenceType newPreference = newPreferenceValue == "wenig"
            ? PreferenceType.NotPreferred
            : newPreferenceValue == "nichts"
                ? PreferenceType.NotWanted
                : PreferenceType.None;
        onChange(changedIngredient, newPreference);
      },
    );
  }
}
