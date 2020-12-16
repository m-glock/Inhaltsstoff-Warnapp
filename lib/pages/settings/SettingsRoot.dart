import './SettingsAgb.dart';
import './SettingsGeneral.dart';
import './SettingsHelp.dart';
import './SettingsImpressum.dart';
import './SettingsPreferences.dart';
import 'package:flutter/material.dart';

class SettingsPage {
  const SettingsPage(this.icon, this.title, this.page);
  final IconData icon;
  final String title;
  final Widget page;
}

const List<SettingsPage> allSettingsPages = <SettingsPage>[
  SettingsPage(Icons.favorite, 'Präferenzen', SettingsPreferences()),
  SettingsPage(Icons.app_settings_alt, 'Allgemein', SettingsGeneral()),
  SettingsPage(Icons.info, 'Impressum', SettingsImpressum()),
  SettingsPage(Icons.format_quote, 'AGB', SettingsAgb()),
  SettingsPage(Icons.help, 'Hilfe', SettingsHelp()),
];

class SettingsRoot extends StatelessWidget {
  const SettingsRoot({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: allSettingsPages.map((SettingsPage settingsPage) {
          return ListTile(
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
          );
        }).toList(),
      ),
    );
  }
}
