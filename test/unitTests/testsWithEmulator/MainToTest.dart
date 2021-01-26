import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:Essbar/backend/database/DatabaseHelper.dart';
import 'package:Essbar/backend/databaseEntities/Product.dart';
import 'package:Essbar/backend/databaseEntities/Ingredient.dart';
import 'package:Essbar/backend/enums/DbTableNames.dart';
import 'package:Essbar/backend/enums/PreferenceType.dart';
import 'package:Essbar/backend/enums/ScanResult.dart';
import 'package:Essbar/backend/enums/Type.dart';
import 'package:Essbar/backend/FoodApiAccess.dart';
import 'package:Essbar/backend/ListManager.dart';
import 'package:Essbar/backend/PreferenceManager.dart';
import 'package:Essbar/frontend/customWidgets/preferences/PreferencesAllergensView.dart';

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
