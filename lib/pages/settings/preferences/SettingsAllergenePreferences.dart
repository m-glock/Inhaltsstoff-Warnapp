import 'package:flutter/material.dart';

class SettingsAllergenePreferences extends StatelessWidget {
  const SettingsAllergenePreferences({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergene Preferences'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Text('Hier sieht man die Allergien.'),
      ),
    );
  }
}