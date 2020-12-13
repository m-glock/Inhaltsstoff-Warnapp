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
            final dbHelper = DatabaseHelper.instance;
            final db = await dbHelper.database;



            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat('yyyy-MM-dd-Hm');
            final String formatted = formatter.format(now);
            print(formatted); // something like 2013-04-20

            Ingredient ingredient = new Ingredient("NameTest1", PreferenceType.Preferred, formatted);

            db.execute("Insert into preferencetype (name) values ('preferred')");
            //await dbHelper.add(Type("Type1"));
            //await dbHelper.add(PreferenceType(PreferenceType.Preferred));
            await dbHelper.add(ingredient);
            print('added Type & Ingredient'); //               <-- logging

            ingredient.changePreference(PreferenceType.NotWanted);


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
