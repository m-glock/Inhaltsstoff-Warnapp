import 'package:Essbar/backend/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';

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
  List<Ingredient> _ingredientsShown;
  int _numItemsPage = 10;
  int _maxItems;
  bool _hasMoreItems;
  bool _loadingMore;

  @override
  void initState() {
    super.initState();
    _filteredIngredients = widget.otherIngredientPreferences.keys.toList();

    _maxItems = widget.otherIngredientPreferences.length;
    _ingredientsShown = List<Ingredient>();
    for (int i = 0; i < _numItemsPage; i++) {
      _ingredientsShown.add(widget.otherIngredientPreferences.keys.elementAt(i));
    }
    _hasMoreItems = true;
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
      IncrementallyLoadingListView(
        hasMore: () => _hasMoreItems,
        itemCount: () => _ingredientsShown.length,
        loadMore: _loadMoreItems,
        onLoadMore: () {
          setState(() {
            _loadingMore = true;
          });
        },
        onLoadMoreFinished: () {
          setState(() {
            _loadingMore = false;
          });
        },
        itemBuilder: (context, index) {
          final item = _ingredientsShown[index];
          if ((_loadingMore ?? false) && index == _ingredientsShown.length - 1) {
            return Column(
              children: <Widget>[
                ItemCard(item: item),
              ],
            );
          }
          return ItemCard(item: item);
        })
        /*RadioButtonTable(
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
        ),*/
      ],
    );
  }



  Future _loadMoreItems() async {
    await Future.delayed(Duration(seconds: 3), () {
      int length = _ingredientsShown.length;
      for (var i = 0; i < _numItemsPage; i++) {
        int index = length + i;
        if(index >= widget.otherIngredientPreferences.length) continue;

        _ingredientsShown.add(widget.otherIngredientPreferences.keys.elementAt(index));
      }
    });

    _hasMoreItems = _ingredientsShown.length < _maxItems;
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Ingredient item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(item.name),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(item.name),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderItemCard extends StatelessWidget {
  const PlaceholderItemCard({Key key, @required this.item}) : super(key: key);

  final Ingredient item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        item.name,
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    item.name,
                    style: TextStyle(color: Colors.transparent),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}
