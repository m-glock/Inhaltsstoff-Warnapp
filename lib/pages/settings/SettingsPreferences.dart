import 'package:flutter/material.dart';

class SettingsPreferences extends StatelessWidget {
  const SettingsPreferences({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Präferenzen'),
        backgroundColor: Theme.of(context).primaryColor,
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