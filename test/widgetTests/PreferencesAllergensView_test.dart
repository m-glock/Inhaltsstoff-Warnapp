// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:Essbar/frontend/customWidgets/preferences/PreferencesAllergensView.dart';
import 'package:Essbar/backend/Enums/PreferenceType.dart';
import 'package:Essbar/backend/Enums/Type.dart';
import 'package:Essbar/backend/Ingredient.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  testWidgets('search and select Ingredients via PreferencesAllergensView',
      (WidgetTester tester) async {
    // mock allergenePreferences map
    Ingredient firstIngredient = Ingredient(
        "Haselnuss", PreferenceType.NotWanted, Type.Allergen, DateTime.now(),
        id: 2);
    Ingredient secondIngredient = Ingredient(
        "Soja", PreferenceType.None, Type.Allergen, DateTime.now(),
        id: 1);
    Map<Ingredient, PreferenceType> mockedAllegenePreferences = {
      firstIngredient: PreferenceType.NotWanted,
      secondIngredient: PreferenceType.None
    };

    // build PreferencesAllergenesView as StatefulWidget inside MaterialApp and Scaffold (important!)
    await tester.pumpWidget(
      new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return new Material(
            child: buildTestableWidget(
              PreferencesAllergensView(
                allergenePreferences: mockedAllegenePreferences,
                onChange: (Ingredient changedIngredient,
                    PreferenceType newPreference) {
                  setState(
                    () {
                      mockedAllegenePreferences[changedIngredient] =
                          newPreference;
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    // rerender widget
    await tester.pump();

    // Verify that our Checkboxlist contains Haselnuss and Soja
    expect(find.text('Haselnuss'), findsOneWidget);
    expect(find.text('Soja'), findsOneWidget);

    // Verify, that Haselnuss is NotWanted and Soja is None
    expect(
        mockedAllegenePreferences[firstIngredient], PreferenceType.NotWanted);
    expect(mockedAllegenePreferences[secondIngredient], PreferenceType.None);

    // enter text in searchBar field
    await tester.enterText(find.byType(TextField), 'Soja');

    // rerender
    await tester.pump();

    // Verify, that only Soja is shown in ne filtered list
    expect(find.text('Haselnuss'), findsNothing);
    // more than 1, since one is located in list, one in the search bar
    expect(find.text('Soja'), findsWidgets);

    // simulate clicking the Checkbox of Soja to change its preference
    await tester.tap(find.byType(CheckboxListTile));

    // rerender
    await tester.pump();

    // Verify, that preferenceType of Soja has changed to NotWanted, where Haselnuss hasn't changed
    expect(
        mockedAllegenePreferences[secondIngredient], PreferenceType.NotWanted);
    expect(
        mockedAllegenePreferences[firstIngredient], PreferenceType.NotWanted);
  });
}
