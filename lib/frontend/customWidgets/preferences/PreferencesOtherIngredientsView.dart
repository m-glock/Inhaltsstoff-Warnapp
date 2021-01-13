import 'package:flutter/material.dart';

import '../RadioButtonTable.dart';
import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/Ingredient.dart';
import '../../customWidgets/RadioButtonTable.dart';
import '../../customWidgets/SearchBar.dart';

class PreferencesOtherIngredientsView extends StatefulWidget {
  PreferencesOtherIngredientsView({
    this.otherIngredientPreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> otherIngredientPreferences;
  final void Function(Ingredient, PreferenceType) onChange;

  @override
  _PreferencesOtherIngredientsViewState createState() =>
      _PreferencesOtherIngredientsViewState();
}

class _PreferencesOtherIngredientsViewState
    extends State<PreferencesOtherIngredientsView> {
  List<Ingredient> _filteredIngredients;

  @override
  void initState() {
    super.initState();
    _filteredIngredients = widget.otherIngredientPreferences.keys.toList();
  }

  void _onFilterList(List<String> newFilteredList) {
    setState(() {
      _filteredIngredients = widget.otherIngredientPreferences.keys
          .toList()
          .where((ingredient) => newFilteredList.contains(ingredient.name))
          .toList();
    });
  }

  Map<Ingredient, PreferenceType> get _filteredOtherIngredientPreferences {
    Map<Ingredient, PreferenceType> newOtherIngredientPreferences = {};
    _filteredIngredients.forEach((ingredient) {
      newOtherIngredientPreferences[ingredient] =
          widget.otherIngredientPreferences[ingredient];
    });
    return newOtherIngredientPreferences;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: SearchBar(
            items: widget.otherIngredientPreferences.keys
                .map((ingredient) => ingredient.name)
                .toList(),
            onFilterList: _onFilterList,
          ),
        ),
        RadioButtonTable(
          items: _filteredOtherIngredientPreferences
              .map((ingredient, preference) => MapEntry(
                  ingredient.name,
                  preference == PreferenceType.None
                      ? "egal"
                      : preference == PreferenceType.NotWanted
                          ? "nichts"
                          : "wenig")),
          options: ["nichts", "egal", "wenig"],
          onChange: (int index, String newPreferenceValue) {
            Ingredient changedIngredient =
                _filteredOtherIngredientPreferences.keys.toList()[index];
            PreferenceType newPreference = newPreferenceValue == "wenig"
                ? PreferenceType.NotPreferred
                : newPreferenceValue == "nichts"
                    ? PreferenceType.NotWanted
                    : PreferenceType.None;
            widget.onChange(changedIngredient, newPreference);
          },
        ),
      ],
    );
  }
}
