import 'package:flutter/material.dart';

import '../CheckboxList.dart';
import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';

class PreferencesAllergensView extends StatelessWidget {
  PreferencesAllergensView({
    this.allergenePreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> allergenePreferences;
  final void Function(Ingredient, PreferenceType) onChange;

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
