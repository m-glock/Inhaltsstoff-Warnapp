import 'package:flutter/material.dart';

class SettingsImpressum extends StatefulWidget {
  const SettingsImpressum({ Key key }) : super(key: key);

  @override
  _SettingsImpressumState createState() => _SettingsImpressumState();
}

class _SettingsImpressumState extends State<SettingsImpressum> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Text('Hier sieht man das Impressum.'),
      ),
    );
  }
}