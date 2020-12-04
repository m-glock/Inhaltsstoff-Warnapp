import 'package:flutter/material.dart';

class SettingsGeneral extends StatelessWidget {
  const SettingsGeneral({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allgemein'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Text('Hier kann man die allgemeinen Einstellungen vornehmen.'),
      ),
    );
  }
}