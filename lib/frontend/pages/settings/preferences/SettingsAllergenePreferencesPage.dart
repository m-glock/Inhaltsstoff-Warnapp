import 'package:flutter/material.dart';

import '../../../../backend/databaseEntities/Ingredient.dart';
import '../../../../backend/enums/PreferenceType.dart';
import '../../../../backend/enums/Type.dart';
import '../../../../backend/PreferenceManager.dart';
import '../../../customWidgets/preferences/PreferencesAllergensView.dart';

class SettingsAllergenePreferencesPage extends StatefulWidget {
  const SettingsAllergenePreferencesPage({
    @required this.onSave,
  });

  final Function onSave;

  @override
  _SettingsAllergenePreferencesPageState createState() =>
      _SettingsAllergenePreferencesPageState();
}

class _SettingsAllergenePreferencesPageState
    extends State<SettingsAllergenePreferencesPage> {
  Map<Ingredient, PreferenceType> _allergenePreferences = Map();

  @override
  void initState() {
    super.initState();
    setIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergien'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => widget.onSave(_allergenePreferences),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _allergenePreferences.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  PreferencesAllergensView(
                    allergenePreferences: _allergenePreferences,
                    onChange: (Ingredient changedIngredient,
                        PreferenceType newPreference) {
                      setState(() {
                        _allergenePreferences[changedIngredient] =
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
    Map<Ingredient, PreferenceType> allergenePreferences =
        await getIngredients(Type.Allergen);
    setState(() {
      _allergenePreferences = allergenePreferences;
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
