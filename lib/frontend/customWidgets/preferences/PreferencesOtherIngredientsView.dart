import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../backend/databaseEntities/Ingredient.dart';
import '../../../backend/enums/PreferenceType.dart';
import '../../customWidgets/RadioButtonTable.dart';
import '../../customWidgets/SearchBar.dart';
import '../RadioButtonTable.dart';

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
  List<Ingredient> _shownIngredients;
  int _itemsToBeLoaded = 50;

  @override
  void initState() {
    super.initState();
    _filteredIngredients = widget.otherIngredientPreferences.keys.toList();
    _shownIngredients = _filteredIngredients.getRange(0, _itemsToBeLoaded).toList();
  }

  void _onFilterList(List<String> newFilteredList) {
    setState(() {
      _filteredIngredients = widget.otherIngredientPreferences.keys
          .toList()
          .where((ingredient) => newFilteredList.contains(ingredient.name))
          .toList();
      _shownIngredients = _filteredIngredients.length < _itemsToBeLoaded
          ? _filteredIngredients
          : _filteredIngredients.getRange(0, _itemsToBeLoaded).toList();
    });
  }

  Map<Ingredient, PreferenceType> get _shownOtherIngredientPreferences {
    Map<Ingredient, PreferenceType> newOtherIngredientPreferences = {};
    _shownIngredients.forEach((ingredient) {
      newOtherIngredientPreferences[ingredient] =
          widget.otherIngredientPreferences[ingredient];
    });
    return newOtherIngredientPreferences;
  }

  void _loadMoreItems() async {
    final int totalItems = _filteredIngredients.length;
    int listLength = _shownIngredients.length;
    List<Ingredient> ingredientsToAdd = new List();

    for (int i = 0; i < _itemsToBeLoaded; i++) {
      int index = listLength + i;
      if (index >= totalItems) continue;
      Ingredient ing = _filteredIngredients.elementAt(index);
      ingredientsToAdd.add(ing);
    }

    setState(() {
      _shownIngredients.addAll(ingredientsToAdd);
    });
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
          items: _shownOtherIngredientPreferences
              .map((ingredient, preference) => MapEntry(
                  ingredient.name,
                  preference == PreferenceType.None
                      ? 'egal'
                      : preference == PreferenceType.NotWanted
                          ? 'nichts'
                          : 'wenig')),
          options: ['nichts', 'egal', 'wenig'],
          onChange: (int index, String newPreferenceValue) {
            Ingredient changedIngredient =
                _shownOtherIngredientPreferences.keys.toList()[index];
            PreferenceType newPreference = newPreferenceValue == 'wenig'
                ? PreferenceType.NotPreferred
                : newPreferenceValue == 'nichts'
                    ? PreferenceType.NotWanted
                    : PreferenceType.None;
            widget.onChange(changedIngredient, newPreference);
          },
        ),
        if(_shownIngredients.length != _filteredIngredients.length) RaisedButton(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(12),
          child: Text(
            'Mehr laden',
            style: Theme.of(context).textTheme.button.merge(
                  new TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
            textAlign: TextAlign.center,
          ),
          onPressed: () => _loadMoreItems(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ],
    );
  }
}
