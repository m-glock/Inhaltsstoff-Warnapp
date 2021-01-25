import 'package:Essbar/backend/ListManager.dart';
import 'file:///C:/Users/Mareike/Documents/Studium/Master/3.Semester-WS2021/WP5_Mobile-Applications-for-Public-Health/Inhaltsstoff-Warnapp/lib/backend/enums/DbTableNames.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:Essbar/backend/Enums/ScanResult.dart';
import 'package:Essbar/backend/PreferenceManager.dart';
import 'file:///C:/Users/Mareike/Documents/Studium/Master/3.Semester-WS2021/WP5_Mobile-Applications-for-Public-Health/Inhaltsstoff-Warnapp/lib/backend/databaseEntities/Product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Essbar/frontend/customWidgets/preferences/PreferencesAllergensView.dart';
import 'package:Essbar/backend/Enums/PreferenceType.dart';
import 'package:Essbar/backend/Enums/Type.dart';
import 'file:///C:/Users/Mareike/Documents/Studium/Master/3.Semester-WS2021/WP5_Mobile-Applications-for-Public-Health/Inhaltsstoff-Warnapp/lib/backend/databaseEntities/Ingredient.dart';
import 'package:Essbar/backend/database/DatabaseHelper.dart';
import 'package:Essbar/backend/FoodApiAccess.dart';
import 'package:Essbar/backend/ListManager.dart';

// Global variable for storing the list of
// cameras available
List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Retrieve the device cameras
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  // set initial values here if desired
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Essbar - Die Inhaltsstoff Warnapp';

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: RaisedButton(
          child: Text('Button'),
          onPressed: () async {
            final dbHelper = DatabaseHelper.instance;
            FoodApiAccess foodApi = FoodApiAccess.instance;

            // add the test at this position
            // ..................................................................
          },
        ),
      ),
    );
  }
}
