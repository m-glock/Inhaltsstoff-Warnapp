import 'package:flutter/material.dart';

class SettingsHelp extends StatelessWidget {
  const SettingsHelp({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hilfe'),
        backgroundColor: Theme.of(context).primaryColor,
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