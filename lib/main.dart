import 'package:flutter/material.dart';

import 'pages/HomePage.dart';
import 'pages/onboarding/main.dart';
import 'pages/settings/SettingsRoot.dart';
import 'pages/WelcomePage.dart';
import 'theme/style.dart';

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
        '/settings': (context) => SettingsRoot(),
        '/welcome': (context) => WelcomePage(),
      },
      initialRoute: '/welcome',
    );
  }
}
