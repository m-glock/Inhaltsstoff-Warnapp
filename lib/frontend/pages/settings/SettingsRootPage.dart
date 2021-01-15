import './SettingsAgbPage.dart';
import './SettingsGeneralPage.dart';
import './SettingsHelpPage.dart';
import './SettingsImpressumPage.dart';
import './preferences/SettingsPreferencesSummaryPage.dart';
import 'package:flutter/material.dart';

class SettingsPage {
  const SettingsPage(this.icon, this.title, this.page);
  final IconData icon;
  final String title;
  final Widget page;
}

List<SettingsPage> allSettingsPages = <SettingsPage>[
  SettingsPage(Icons.favorite, 'Präferenzen', SettingsPreferencesSummaryPage()),
  SettingsPage(Icons.app_settings_alt, 'Allgemein', SettingsGeneralPage()),
  SettingsPage(Icons.info, 'Impressum', SettingsImpressumPage()),
  SettingsPage(Icons.format_quote, 'AGB', SettingsAgbPage()),
  SettingsPage(Icons.help, 'Hilfe', SettingsHelpPage()),
];

class SettingsRootPage extends StatelessWidget {
  const SettingsRootPage({Key key}) : super(key: key);

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
