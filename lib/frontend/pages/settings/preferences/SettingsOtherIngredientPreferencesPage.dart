import 'package:flutter/material.dart';

import '../../../../backend/Enums/PreferenceType.dart';
import '../../../../backend/databaseEntities/Ingredient.dart';
import '../../../../backend/PreferenceManager.dart';
import '../../../../backend/Enums/Type.dart';
import '../../../customWidgets/preferences/PreferencesOtherIngredientsView.dart';

class SettingsOtherIngredientPreferencesPage extends StatefulWidget {
  const SettingsOtherIngredientPreferencesPage({
    @required this.onSave,
  });

  final Function onSave;

  @override
  _SettingsOtherIngredientPreferencesPageState createState() =>
      _SettingsOtherIngredientPreferencesPageState();
}

class _SettingsOtherIngredientPreferencesPageState
    extends State<SettingsOtherIngredientPreferencesPage> {
  Map<Ingredient, PreferenceType> _otherIngredientPreferences = Map();

  @override
  void initState() {
    super.initState();
    setIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unerwünschte Inhaltsstoffe'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => widget.onSave(_otherIngredientPreferences),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _otherIngredientPreferences.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  PreferencesOtherIngredientsView(
                    otherIngredientPreferences: _otherIngredientPreferences,
                    onChange: (Ingredient changedIngredient,
                        PreferenceType newPreference) {
                      setState(() {
                        _otherIngredientPreferences[changedIngredient] =
                            newPreference;
                      });
                    },
                  ),
                ],
              ),
      ),
    );
  }

  void setIngredients() async {
    Map<Ingredient, PreferenceType> otherIngredientPreferences =
        await getIngredients(Type.General);
    setState(() {
      _otherIngredientPreferences = otherIngredientPreferences;
    });
  }

  Future<Map<Ingredient, PreferenceType>> getIngredients(Type type) async {
    List<Ingredient> getAllAvailIg =
        await PreferenceManager.getAllAvailableIngredients(type);
    return Map.fromIterable(
        getAllAvailIg.where((ingredient) => ingredient.type == type),
        key: (ingredient) => ingredient,
        value: (ingredient) => ingredient.preferenceType);
  }
}
