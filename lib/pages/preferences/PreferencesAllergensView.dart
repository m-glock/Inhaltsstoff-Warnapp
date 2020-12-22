import 'package:Inhaltsstoff_Warnapp/customWidgets/SearchBar.dart';
import 'package:flutter/material.dart';

import '../../customWidgets/CheckboxList.dart';
import '../../backend/Enums/PreferenceType.dart';
import '../../backend/Ingredient.dart';

class PreferencesAllergensView extends StatefulWidget {
  PreferencesAllergensView({
    this.allergenePreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> allergenePreferences;
  final void Function(Ingredient, PreferenceType) onChange;

  @override
  _PreferencesAllergensViewState createState() =>
      _PreferencesAllergensViewState();
}

class _PreferencesAllergensViewState extends State<PreferencesAllergensView> {
  Map<Ingredient, PreferenceType> _filteredAllergenePreferences;

  @override
  void initState() {
    super.initState();
    _filteredAllergenePreferences = widget.allergenePreferences;
  }

  void _onFilterList(List<String> newFilteredList) {
    List<Ingredient> filteredIngredients = widget.allergenePreferences.keys
        .toList()
        .where((ingredient) => newFilteredList.contains(ingredient.name))
        .toList();
    Map<Ingredient, PreferenceType> newAllergenePreferences = {};
    filteredIngredients.forEach((ingredient) {
      newAllergenePreferences[ingredient] =
          widget.allergenePreferences[ingredient];
    });
    setState(() {
      _filteredAllergenePreferences = newAllergenePreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          items: widget.allergenePreferences.keys
              .map((ingredient) => ingredient.name)
              .toList(),
          onFilterList: _onFilterList,
        ),
        CheckboxList(
          items: _filteredAllergenePreferences.map(
            (ingredient, preference) => MapEntry(ingredient.name,
                preference == PreferenceType.None ? false : true),
          ),
          onChange: (int index, bool hasBeenSelected) {
            Ingredient changedIngredient =
                _filteredAllergenePreferences.keys.toList()[index];
            PreferenceType newPreference = hasBeenSelected
                ? PreferenceType.NotWanted
                : PreferenceType.None;
            widget.onChange(changedIngredient, newPreference);
          },
        ),
      ],
    );
  }
}
