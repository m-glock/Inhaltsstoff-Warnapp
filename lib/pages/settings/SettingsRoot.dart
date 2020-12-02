import 'package:flutter/material.dart';

class SettingsPage {
  const SettingsPage(this.icon, this.title, this.route);
  final IconData icon;
  final String title;
  final String route;
}

const List<SettingsPage> allSettingsPages = <SettingsPage>[
  SettingsPage(Icons.favorite, 'Präferenzen', '/preferences'),
  SettingsPage(Icons.app_settings_alt, 'Allgemein', '/general'),
  SettingsPage(Icons.info, 'Impressum', '/impressum'),
  SettingsPage(Icons.format_quote, 'AGB', '/agb'),
  SettingsPage(Icons.help, 'Hilfe', '/help'),
];

class SettingsRoot extends StatefulWidget {
  const SettingsRoot({ Key key }) : super(key: key);

  @override
  _SettingsRootState createState() => _SettingsRootState();
}

class _SettingsRootState extends State<SettingsRoot> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children:
          allSettingsPages.map((SettingsPage settingsPage) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, settingsPage.route);
              },
              child: ListTile(
                leading: Icon(settingsPage.icon, color: Theme.of(context).primaryColor),
                title: Text(settingsPage.title, style: Theme.of(context).textTheme.headline2),
                trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).primaryColor),
              ),
            );
          }).toList(),
      ),
    );
  }
}