import 'package:Inhaltsstoff_Warnapp/pages/settings/SettingsRoot.dart';
import 'package:flutter/material.dart';

import 'pages/HomePage.dart';
import 'pages/onboarding/main.dart';
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
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/settings': (context) => SettingsRoot(),
      },
      initialRoute: '/',
    );
  }
}
