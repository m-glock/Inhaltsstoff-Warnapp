import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'backend/Enums/PreferenceType.dart';
import 'backend/Ingredient.dart';
import 'backend/database/DbTableNames.dart';
import 'backend/database/databaseHelper.dart';
import 'pages/HomePage.dart';
import 'pages/onboarding/main.dart';
import 'theme/style.dart';
import 'package:intl/intl.dart';

void main() {
  SharedPreferences.setMockInitialValues(
      {}); // set initial values here if desired
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: RaisedButton(
          child: Text('Button'),
          onPressed: () async {
            //vars
            final dbHelper = DatabaseHelper.instance;
            final db = await dbHelper.database;


            //method for getCurrentTime
            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat('yyyy-MM-dd-Hm');
            final String formatted = formatter.format(now);
            //print(formatted); // something like 2013-04-20

            //Ingredient ingredient = new Ingredient("NameTest3", PreferenceType.Preferred, formatted);

            //db.execute("Insert into preferencetype (name) values ('preferred')");
            //await dbHelper.add(Type("Type1"));
            //await dbHelper.add(PreferenceType(PreferenceType.Preferred));

            //await dbHelper.add(Ingredient("NameTest3", PreferenceType.Preferred, formatted));
            //print('added Type & Ingredient'); //               <-- logging

            //ingredient.changePreference(PreferenceType.NotWanted);


            //List<Map> results_preference_type = await dbHelper.readAll(DbTableNames.preferenceType);
            //print(results_preference_type);
            //List<Ingredient> ingredients1 = List();
            await db.rawInsert("Insert into type (name) values ('Allergen')");
            await db.rawInsert("Insert into type (name) values ('Nutriment')");
            await db.rawInsert("Insert into type (name) values ('General')");
            await db.rawInsert("Insert into preferencetype (name) values ('notwanted')");
            await db.rawInsert("Insert into preferencetype (name) values ('notpreferred')");
            await db.rawInsert("Insert into preferencetype (name) values ('preferred')");
            await db.rawInsert("Insert into preferencetype (name) values ('none')");


            //not correct


            //dbHelper.add(Ingredient('Zucker', PreferenceType.NotWanted, formatted));


            //dbHelper.add(Ingredient('Milch', PreferenceType.NotWanted, formatted));
            //dbHelper.add(Ingredient('Magnesium', PreferenceType.NotPreferred, formatted));
            //dbHelper.add(Ingredient('Wasser', PreferenceType.Preferred, formatted));

            //List<Map> results = await db.query("ingredient", columns: Ingredient.columns, orderBy: "id DESC");
            List<Map> results = await db.rawQuery("select i.name, i.preferencesTypeId, i.addDate, i.id, p.name preferenceType from ingredient i join preferencetype p on i.preferencesTypeId=p.id where i.preferencesTypeId is not 'NONE'");

            results.forEach((element) {
              print(element);
            });

            List<Ingredient> ingredients = new List();
            results.forEach((result) {

              Ingredient ingredient = Ingredient.fromMap(result);
              ingredients.add(ingredient);
            });

            ingredients.forEach((element) {
              print(element);
            });

            //return ingredients;

            List<Map> test = await dbHelper.readAll(DbTableNames.type);
            List<Map> test1 = await dbHelper.readAll(DbTableNames.ingredient);
            List<Map> test2 = await dbHelper.readAll(DbTableNames.preferenceType);
            print(test);
            print(test1);
            print(test2);




          },
        ),
      ),
    );
  }
}

/// This is the main application widget.
// class MyApp extends StatelessWidget {
//   static const String _title = 'Inhaltsstoff Warnapp';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       theme: appTheme(),
//       home: MyStatefulWidget(),
//     );
//   }
// }

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 2000), () {
      checkFirstSeen();
    });
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _firstTime = (prefs.getBool('firstTime') ?? true);

    if (_firstTime) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new OnboardingPage()));
    } else {
      await prefs.setBool('firstTime', false);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomePage()));
    }
  }

  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Willkommen!'),
      ),
    );
  }
}
