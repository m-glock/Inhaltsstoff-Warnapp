import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './frontend/pages/HomePage.dart';
import './frontend/pages/onboarding/main.dart';
import './frontend/pages/WelcomePage.dart';
import './frontend/theme/style.dart';
import './frontend/pages/settings/SettingsRootPage.dart';
import './frontend/pages/settings/SettingsAgbPage.dart';
import './frontend/pages/settings/SettingsGeneralPage.dart';
import './frontend/pages/settings/SettingsHelpPage.dart';
import './frontend/pages/settings/SettingsImpressumPage.dart';
import './frontend/pages/settings/preferences/SettingsAllergenePreferencesPage.dart';
import './frontend/pages/settings/preferences/SettingsNutrientPreferencesPage.dart';
import './frontend/pages/settings/preferences/SettingsOtherIngredientPreferencesPage.dart';
import './frontend/pages/settings/preferences/SettingsPreferencesSummaryPage.dart';
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
        '/welcome': (context) => WelcomePage(),
        // global settings page and subpages
        '/settings': (context) => SettingsRootPage(),
        '/settings/preferences': (context) => SettingsPreferencesSummaryPage(),
        '/settings/preferences/allergenes': (context) =>
            SettingsAllergenePreferencesPage(
                onSave: ModalRoute.of(context).settings.arguments),
        '/settings/preferences/nutrients': (context) =>
            SettingsNutrientPreferencesPage(
                onSave: ModalRoute.of(context).settings.arguments),
        '/settings/preferences/otherIngredients': (context) =>
            SettingsOtherIngredientPreferencesPage(
                onSave: ModalRoute.of(context).settings.arguments),
        '/settings/general': (context) => SettingsGeneralPage(),
        '/settings/impressum': (context) => SettingsImpressumPage(),
        '/settings/agb': (context) => SettingsAgbPage(),
        '/settings/help': (context) => SettingsHelpPage(),
      },
      initialRoute: '/welcome',
    );
  }
}