import 'package:flutter/material.dart';

import '../../customWidgets/CheckboxList.dart';
import '../../backend/Enums/PreferenceType.dart';
import '../../backend/Ingredient.dart';

class OnboardingAllergensView extends StatelessWidget {
  OnboardingAllergensView({
    this.allergenePreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> allergenePreferences;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    // TODO: render Search Bar
    return CheckboxList(
      items: allergenePreferences.map((ingredient, preference) => MapEntry(
          ingredient.name, preference == PreferenceType.None ? false : true)),
      onChange: (int index, bool hasBeenSelected) {
        Ingredient changedIngredient =
            allergenePreferences.keys.toList()[index];
        PreferenceType newPreference =
            hasBeenSelected ? PreferenceType.NotWanted : PreferenceType.None;
        onChange(changedIngredient, newPreference);
      },
    );
  }
}
