import 'package:flutter/material.dart';
import 'dart:async';

import '../../backend/database/databaseHelper.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  waitforDatabaseBeforeRouting() async {
    List<Map<String, dynamic>> map = await DatabaseHelper.instance.customQuery('SELECT * FROM metadataFlags WHERE name = \'Onboarding\'');
    int isOnboardingDone = map[0]['isInitialized'] as int;
    if (isOnboardingDone == 0) {
      await DatabaseHelper.instance.customQuery('UPDATE metadataFlags SET isInitialized=1 WHERE name = \'Onboarding\'');
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    new Timer(new Duration(milliseconds: 1000), () {
      waitforDatabaseBeforeRouting();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              child: Text("Welcome!"),
              padding: EdgeInsets.all(12.0),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
