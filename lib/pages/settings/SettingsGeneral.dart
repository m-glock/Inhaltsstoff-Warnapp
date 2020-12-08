import 'package:flutter/material.dart';

class SettingsGeneral extends StatefulWidget {
  const SettingsGeneral({Key key,}) : super(key: key);

  @override
  _SettingsGeneralState createState() => _SettingsGeneralState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SettingsGeneralState extends State<SettingsGeneral> {
  double _currentTextSize;

  List<String> _availableLanguages = ['Deutsch', 'English'];
  String _currentLaguage = 'Deutsch';

  @override
  void initState() {
    super.initState();
    //TODO: get currentTextSize
    _currentTextSize = 14;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allgemein'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ExpansionTile(
            title: Text(
              'Textgröße', 
              style: Theme.of(context).textTheme.headline2
            ),
            children: [
              Slider(
                  value: _currentTextSize,
                  min: 10,
                  max: 20,
                  divisions: 10,
                  label: _currentTextSize.toString(),
                  onChanged: (double value) {
                    setState(() {
                      //TODO: actually set text size
                      _currentTextSize = value;
                    });
                  }
              )
            ],
            initiallyExpanded: true,
          ),
          ExpansionTile(
            title: Text(
              'Sprache',
              style: Theme.of(context).textTheme.headline2
            ),
            children: _availableLanguages.map((language) {
              return RadioListTile(
                title: Text(language, style: Theme.of(context).textTheme.bodyText1),
                value: language,
                selected: language == _currentLaguage,
                groupValue: _currentLaguage,
                onChanged: (String value) {
                  setState(() {
                    _currentLaguage = value;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              );
            }).toList(),
            initiallyExpanded: true,
          )
        ],
      ),
    );
  }
}