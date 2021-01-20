import 'package:Essbar/frontend/customWidgets/ComingSoonView.dart';
import 'package:flutter/material.dart';

class SettingsGeneralPage extends StatelessWidget {
  const SettingsGeneralPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allgemein'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ComingSoonView(
        teaser: 'Hier kannst du bald Schriftgröße, Sprache und Co. ändern.',
      ),
    );
  }
}
