import 'package:flutter/material.dart';

class SettingsPreferences extends StatefulWidget {
  const SettingsPreferences({ Key key }) : super(key: key);

  @override
  _SettingsPreferencesState createState() => _SettingsPreferencesState();
}

class _SettingsPreferencesState extends State<SettingsPreferences> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Präferenzen'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Text('Hier kann man die Präferenzen einstellen.'),
      ),
    );
  }
}