import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './frontend/pages/HomePage.dart';
import './frontend/pages/onboarding/main.dart';
import './frontend/pages/settings/SettingsRootPage.dart';
import './frontend/pages/WelcomePage.dart';
import './frontend/theme/style.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: appTheme(),
      routes: {
        '/': (context) => HomePage(),
        '/onboarding': (context) => OnboardingPage(),
        '/settings': (context) => SettingsRootPage(),
        '/welcome': (context) => WelcomePage(),
      },
      initialRoute: '/welcome',
    );
  }
}