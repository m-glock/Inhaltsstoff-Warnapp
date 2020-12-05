import './SettingsAgb.dart';
import './SettingsGeneral.dart';
import './SettingsHelp.dart';
import './SettingsImpressum.dart';
import './SettingsPreferences.dart';
import 'package:flutter/material.dart';

class SettingsPage {
  SettingsPage(this.icon, this.title, this.page, [this.settings]){
    this.settings ??= new Map();
  }
  IconData icon;
  String title;
  Widget page;
  Map<String, List<String>> settings;
}

class SettingsRoot extends StatelessWidget {
  SettingsRoot({Key key}) : super(key: key);

  //TODO: get current general and preferences settings from backend
  // to be able to add them to this list and show them in preview
  List<SettingsPage> _allSettingsPages = <SettingsPage>[
      SettingsPage(
          Icons.favorite,
          'Präferenzen',
          SettingsPreferences(),
          {
            'Allergien': ['Allergen 1, Allergen 2'],
            'Gewünschte Nährstoffe': ['Magnesium', 'B12'],
            'Ungewollte Inhaltsstoffe': ['Inhaltsstoff x']
          }
      ),
      SettingsPage(
          Icons.app_settings_alt,
          'Allgemein',
          SettingsGeneral(),
          {
            'Textgröße': ['small'],
            'Sprache': ['Deutsch']
          }
      ),
      SettingsPage(Icons.info, 'Impressum', SettingsImpressum()),
      SettingsPage(Icons.format_quote, 'AGB', SettingsAgb()),
      SettingsPage(Icons.help, 'Hilfe', SettingsHelp()),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: _allSettingsPages.map((SettingsPage settingsPage) {
          return Column(
            children: [
              ListTile(
              leading: Icon(settingsPage.icon,
                  color: Theme.of(context).primaryColor),
              title: Text(settingsPage.title,
                  style: Theme.of(context).textTheme.headline2),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => settingsPage.page));
                },
              ),
              Column(
                children: settingsPage.settings.entries.map((setting) {
                  return ListTile(
                    title: Text(setting.key,
                        style: Theme.of(context).textTheme.bodyText1),
                    trailing: Text(
                        setting.value.reduce((value, element) => value + ', ' + element),
                        style: Theme.of(context).textTheme.bodyText2
                    ),
                  );
                }).toList(),
              )
            ]
          );
        }).toList(),
      ),
    );
  }
}
