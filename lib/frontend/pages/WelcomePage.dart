import 'package:Inhaltsstoff_Warnapp/backend/ListManager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _firstTime = (prefs.getBool('firstTime') ?? true);

    if (_firstTime) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      await prefs.setBool('firstTime', false);
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    new Timer(new Duration(milliseconds: 1000), () {
      checkFirstSeen();
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
