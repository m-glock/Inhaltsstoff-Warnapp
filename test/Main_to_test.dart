//put in the main class to test some db objects with the real application (actions per button)
// import 'package:EssBar/backend/PreferenceManager.dart';
// import 'package:EssBar/backend/Product.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:async';
//
// import 'backend/Enums/PreferenceType.dart';
// import 'backend/Ingredient.dart';
// import 'backend/Enums/Type.dart';
// import 'backend/database/DbTableNames.dart';
// import 'backend/database/DatabaseHelper.dart';
// import 'pages/HomePage.dart';
// import 'pages/onboarding/main.dart';
// import 'theme/style.dart';
// import 'package:intl/intl.dart';
//
// void main() {
//   SharedPreferences.setMockInitialValues(
//       {}); // set initial values here if desired
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Center(
//         child: RaisedButton(
//           child: Text('Button'),
//           onPressed: () async {
//             //vars
//             final dbHelper = DatabaseHelper.instance;
//             final db = await dbHelper.database;
//
//
//             //method for getCurrentTime
//             final DateTime now = DateTime.now();
//             final DateFormat formatter = DateFormat('yyyy-MM-dd-Hm');
//             final String formatted = formatter.format(now);
//             //print(formatted); // something like 2013-04-20
//
//             //Ingredient ingredient = new Ingredient("NameTest3", PreferenceType.Preferred, formatted);
//
//             //db.execute("Insert into preferencetype (name) values ('preferred')");
//             //await dbHelper.add(Type("Type1"));
//             //await dbHelper.add(PreferenceType(PreferenceType.Preferred));
//
//             //await dbHelper.add(Ingredient("NameTest3", PreferenceType.Preferred, formatted));
//             //print('added Type & Ingredient'); //               <-- logging
//
//             //ingredient.changePreference(PreferenceType.NotWanted);
//
//
//             //List<Map> results_preference_type = await dbHelper.readAll(DbTableNames.preferenceType);
//             //print(results_preference_type);
//             //List<Ingredient> ingredients1 = List();
//
//
//             //initialize table
//             /*await db.rawInsert("INSERT INTO scanresult (name) VALUES ('Red')");
//             await db.rawInsert("INSERT INTO scanresult (name) VALUES ('Yellow')");
//             await db.rawInsert("INSERT INTO scanresult (name) VALUES ('Green')");
//             await db.rawInsert("INSERT INTO preferencetype (name) VALUES ('Not Wanted')");
//             await db.rawInsert("INSERT INTO preferencetype (name) VALUES ('Not Preferred')");
//             await db.rawInsert("INSERT INTO preferencetype (name) VALUES ('Preferred')");
//             await db.rawInsert("INSERT INTO preferencetype (name) VALUES ('None')");
//             await db.rawInsert("INSERT INTO type (name) VALUES ('Allergen')");
//             await db.rawInsert("INSERT INTO type (name) VALUES ('Nutriment')");
//             await db.rawInsert("INSERT INTO type (name) VALUES ('General')");*/
//
//             //print(await dbHelper.readAll(DbTableNames.preferenceType));
//             // print(await dbHelper.readAll(DbTableNames.type));
//             // print(await dbHelper.readAll(DbTableNames.ingredient));
//
//
//             //not correct
//
//
//             //dbHelper.add(Ingredient('Zucker', PreferenceType.NotWanted, formatted));
//
//
//             //dbHelper.add(Ingredient('Milch', PreferenceType.NotWanted, formatted));
//             //Ingredient ingredient_milch = Ingredient("Gluten", PreferenceType.NotWanted, Type.General, "null" );
//
//
//             //await dbHelper.readAll(DbTableNames.ingredient);
//             //Map<Ingredient, PreferenceType> preferenceToChange = {ingredient_milch:PreferenceType.NotPreferred};
//
//             //PreferenceManager.changePreference(preferenceToChange);
//
//             //await dbHelper.readAll(DbTableNames.product);
//             //await dbHelper.read(1, DbTableNames.preferenceType);
//
//             //PreferenceManager.getItemizedScanResults(Product(_name, _imageUrl, _barcode, _scanDate))
//
//
//             /*
//             List<PreferenceType> preferenceTypes = List<PreferenceType>();
//             preferenceTypes.add(PreferenceType.NotWanted);
//             print(preferenceTypes);
//
//             PreferenceManager.getPreferencedIngredients(preferenceTypes);
// */
//
//
//
//
//             //dbHelper.add(Ingredient('Magnesium', PreferenceType.NotPreferred, formatted, Type.Allergen));
//             //dbHelper.add(Ingredient('Wasser', PreferenceType.Preferred, formatted, Type.Nutriment));
//
//
//             //print(await dbHelper.readAll(DbTableNames.preferenceType));
//
//             //List<Map> results = await db.query("ingredient", columns: Ingredient.columns, orderBy: "id DESC");
//             //List<Map> results = await db.rawQuery("select i.name, i.preferenceTypeId, i.preferenceAddDate, i.id, p.name preferenceType from ingredient i join preferencetype p on i.preferenceTypeId=p.id where i.preferenceTypeId is not 'NONE'");
//
//             //print(results);
//
//             // results.forEach((element) {
//             //   print(element);
//             // });
//
//
//
//             /*
//             List<Ingredient> ingredients = new List();
//             results.forEach((result) {
//
//               Ingredient ingredient = Ingredient.fromMap(result);
//               ingredients.add(ingredient);
//             });
//
//             ingredients.forEach((element) {
//               print(element);
//             });
//
//             //return ingredients;
//
//             List<Map> test = await dbHelper.readAll(DbTableNames.type);
//             List<Map> test1 = await dbHelper.readAll(DbTableNames.ingredient);
//             List<Map> test2 = await dbHelper.readAll(DbTableNames.preferenceType);
//             print(test);
//             print(test1);
//             print(test2);
//
//
// */
//
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// This is the main application widget.
// // class MyApp extends StatelessWidget {
// //   static const String _title = 'Inhaltsstoff Warnapp';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: _title,
// //       theme: appTheme(),
// //       home: MyStatefulWidget(),
// //     );
// //   }
// // }
//
// /// This is the stateful widget that the main application instantiates.
// class MyStatefulWidget extends StatefulWidget {
//   MyStatefulWidget({Key key}) : super(key: key);
//
//   @override
//   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
// }
//
// /// This is the private State class that goes with MyStatefulWidget.
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   @override
//   void initState() {
//     super.initState();
//     new Timer(new Duration(milliseconds: 2000), () {
//       checkFirstSeen();
//     });
//   }
//
//   Future checkFirstSeen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool _firstTime = (prefs.getBool('firstTime') ?? true);
//
//     if (_firstTime) {
//       Navigator.of(context).pushReplacement(
//           new MaterialPageRoute(builder: (context) => new OnboardingPage()));
//     } else {
//       await prefs.setBool('firstTime', false);
//       Navigator.of(context).pushReplacement(
//           new MaterialPageRoute(builder: (context) => new HomePage()));
//     }
//   }
//
//   void afterFirstLayout(BuildContext context) => checkFirstSeen();
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: new Center(
//         child: new Text('Willkommen!'),
//       ),
//     );
//   }
// }
