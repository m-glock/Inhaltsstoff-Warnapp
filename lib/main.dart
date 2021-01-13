import 'package:flutter/material.dart';

import './frontend/pages/HomePage.dart';
import './frontend/pages/onboarding/main.dart';
import './frontend/pages/settings/SettingsRootPage.dart';
import './frontend/pages/WelcomePage.dart';
import './frontend/theme/style.dart';

void main() {
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Inhaltsstoff Warnapp';

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