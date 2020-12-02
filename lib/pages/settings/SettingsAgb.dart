import 'package:flutter/material.dart';

class SettingsAgb extends StatefulWidget {
  const SettingsAgb({ Key key }) : super(key: key);

  @override
  _SettingsAgbState createState() => _SettingsAgbState();
}

class _SettingsAgbState extends State<SettingsAgb> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGB'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Text('Hier sieht man die AGB.'),
      ),
    );
  }
}