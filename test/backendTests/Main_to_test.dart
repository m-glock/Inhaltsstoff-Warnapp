// import 'package:Essbar/backend/database/DbTableNames.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:intl/intl.dart';
//
// import 'package:Essbar/backend/Enums/ScanResult.dart';
// import 'package:Essbar/backend/PreferenceManager.dart';
// import 'package:Essbar/backend/Product.dart';
// import 'package:Essbar/main.dart';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:Essbar/frontend/customWidgets/preferences/PreferencesAllergensView.dart';
// import 'package:Essbar/backend/Enums/PreferenceType.dart';
// import 'package:Essbar/backend/Enums/Type.dart';
// import 'package:Essbar/backend/Ingredient.dart';
//
// import 'backend/database/DatabaseHelper.dart';
// // Global variable for storing the list of
// // cameras available
// List<CameraDescription> cameras = [];
//
// Future<void> main() async {
//   try {
//     WidgetsFlutterBinding.ensureInitialized();
//     // Retrieve the device cameras
//     cameras = await availableCameras();
//   } on CameraException catch (e) {
//     print(e);
//   }
//   // set initial values here if desired
//   runApp(MyApp());
// }
//
// /// This is the main application widget.
// class MyApp extends StatelessWidget {
//   static const String _title = 'Essbar - Die Inhaltsstoff Warnapp';
//
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
//            // add the test at this position
// ..................................................................
//
//           },
//         ),
//       ),
//     );
//   }
// }