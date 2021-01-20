import 'package:flutter/material.dart';

class SettingsPage {
  const SettingsPage(this.icon, this.title, this.route);
  final IconData icon;
  final String title;
  final String route;
}

List<SettingsPage> allSettingsPages = <SettingsPage>[
  SettingsPage(Icons.favorite, 'Präferenzen', '/settings/preferences'),
  SettingsPage(Icons.app_settings_alt, 'Allgemein', '/settings/general'),
  SettingsPage(Icons.info, 'Impressum', '/settings/impressum'),
  SettingsPage(Icons.format_quote, 'AGB', '/settings/agb'),
  SettingsPage(Icons.help, 'Hilfe', '/settings/help'),
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
            leading:
                Icon(settingsPage.icon, color: Theme.of(context).primaryColor),
            title: Text(settingsPage.title,
                style: Theme.of(context).textTheme.headline2),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Theme.of(context).primaryColor),
            onTap: () {
              Navigator.pushNamed(context, settingsPage.route);
            },
          );
        }).toList(),
      ),
    );
  }
}
