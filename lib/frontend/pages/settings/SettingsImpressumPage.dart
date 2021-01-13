import 'package:flutter/material.dart';

class SettingsImpressumPage extends StatelessWidget {
  const SettingsImpressumPage({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
        backgroundColor: Theme.of(context).primaryColor,
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