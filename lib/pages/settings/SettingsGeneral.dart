import 'package:flutter/material.dart';

class SettingsGeneral extends StatefulWidget {
  const SettingsGeneral({ Key key }) : super(key: key);

  @override
  _SettingsGeneralState createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends State<SettingsGeneral> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allgemein'),
        backgroundColor: Colors.blue,
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