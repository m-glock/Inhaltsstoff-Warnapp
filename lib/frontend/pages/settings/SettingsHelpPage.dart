import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../customWidgets/LabelledIconButton.dart';

class SettingsHelpPage extends StatelessWidget {
  const SettingsHelpPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hilfe'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Bedienungsanleitung',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Wenn Sie Probleme mit der Bedienung der EssBar-App haben, klicken Sie auf den folgenden Button um das Benutzhandbuch aufzurufen.',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: LabelledIconButton(
                  label: 'Bedienungsanleitung',
                  icon: Icons.link,
                  isPrimary: true,
                  onPressed: _launchURL,
                )),
          ],
        ));
  }

  _launchURL() async {
    const url =
        'https://github.com/m-glock/Inhaltsstoff-Warnapp/wiki/Bedienungsanleitung/';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true);
    } else {
      throw '$url konnte nicht geöffnet werden.';
    }
  }
}
