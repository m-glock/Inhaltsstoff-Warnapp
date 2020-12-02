import 'package:flutter/material.dart';

class SettingsHelp extends StatefulWidget {
  const SettingsHelp({ Key key }) : super(key: key);

  @override
  _SettingsHelpState createState() => _SettingsHelpState();
}

class _SettingsHelpState extends State<SettingsHelp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hilfe'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Text('Hier bekommt man Hilfe.'),
      ),
    );
  }
}