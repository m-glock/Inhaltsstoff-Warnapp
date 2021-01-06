import 'package:flutter/material.dart';

import '../../customWidgets/CheckboxList.dart';
import '../../backend/Enums/PreferenceType.dart';
import '../../backend/Ingredient.dart';

class OnboardingNutrientsView extends StatelessWidget {
  OnboardingNutrientsView({
    this.nutrientPreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> nutrientPreferences;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    // TODO: render Search Bar
    return CheckboxList(
      items: nutrientPreferences.map((ingredient, preference) => MapEntry(
          ingredient.name, preference == PreferenceType.None ? false : true)),
      onChange: (int index, bool hasBeenSelected) {
        Ingredient changedIngredient =
            nutrientPreferences.keys.toList()[index];
        PreferenceType newPreference =
            hasBeenSelected ? PreferenceType.Preferred : PreferenceType.None;
        onChange(changedIngredient, newPreference);
      },
    );
  }
}
