import 'package:flutter/material.dart';

class SettingsImpressumPage extends StatelessWidget {
  const SettingsImpressumPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'Kontakt',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_rounded,
                color: Theme.of(context).primaryColor),
            title: Text('MAPH Software\nStrasse 1\n12345 Berlin',
                style: Theme.of(context).textTheme.headline2),
          ),
          ListTile(
            leading:
                Icon(Icons.local_phone, color: Theme.of(context).primaryColor),
            title: Text('01234567890',
                style: Theme.of(context).textTheme.headline2),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
            title: Text('info@essbar.eat',
                style: Theme.of(context).textTheme.headline2),
          ),
        ],
      ),
    );
  }
}
