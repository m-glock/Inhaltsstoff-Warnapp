import 'package:flutter/material.dart';

import '../CheckboxList.dart';
import '../../../backend/Enums/PreferenceType.dart';
import '../../../backend/databaseEntities/Ingredient.dart';
import '../../customWidgets/CheckboxList.dart';
import '../../customWidgets/SearchBar.dart';

class PreferencesNutrientsView extends StatefulWidget {
  PreferencesNutrientsView({
    this.nutrientPreferences,
    this.onChange,
  });

  final Map<Ingredient, PreferenceType> nutrientPreferences;
  final void Function(Ingredient, PreferenceType) onChange;

  @override
  _PreferencesNutrientsViewState createState() =>
      _PreferencesNutrientsViewState();
}

class _PreferencesNutrientsViewState extends State<PreferencesNutrientsView> {
  List<Ingredient> _filteredIngredients;

  @override
  void initState() {
    super.initState();
    _filteredIngredients = widget.nutrientPreferences.keys.toList();
  }

  void _onFilterList(List<String> newFilteredList) {
    setState(() {
      _filteredIngredients = widget.nutrientPreferences.keys
          .toList()
          .where((ingredient) => newFilteredList.contains(ingredient.name))
          .toList();
    });
  }

  Map<Ingredient, PreferenceType> get _filteredNutrientPreferences {
    Map<Ingredient, PreferenceType> newNutrientPreferences = {};
    _filteredIngredients.forEach((ingredient) {
      newNutrientPreferences[ingredient] =
          widget.nutrientPreferences[ingredient];
    });
    return newNutrientPreferences;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          items: widget.nutrientPreferences.keys
              .map((ingredient) => ingredient.name)
              .toList(),
          onFilterList: _onFilterList,
        ),
        CheckboxList(
          items: _filteredNutrientPreferences.map(
            (ingredient, preference) => MapEntry(ingredient.name,
                preference == PreferenceType.None ? false : true),
          ),
          onChange: (int index, bool hasBeenSelected) {
            Ingredient changedIngredient =
                _filteredNutrientPreferences.keys.toList()[index];
            PreferenceType newPreference = hasBeenSelected
                ? PreferenceType.Preferred
                : PreferenceType.None;
            widget.onChange(changedIngredient, newPreference);
          },
        ),
      ],
    );
  }
}
