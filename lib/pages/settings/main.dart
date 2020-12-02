import 'package:Inhaltsstoff_Warnapp/pages/settings/SettingsAgb.dart';
import 'package:Inhaltsstoff_Warnapp/pages/settings/SettingsGeneral.dart';
import 'package:Inhaltsstoff_Warnapp/pages/settings/SettingsHelp.dart';
import 'package:Inhaltsstoff_Warnapp/pages/settings/SettingsImpressum.dart';
import 'package:Inhaltsstoff_Warnapp/pages/settings/SettingsPreferences.dart';
import 'package:flutter/material.dart';
import 'SettingsRoot.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({ Key key }) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return SettingsRoot();
              case '/preferences':
                return SettingsPreferences();
              case '/general':
                return SettingsGeneral();
              case '/impressum':
                return SettingsImpressum();
              case '/agb':
                return SettingsAgb();
              case '/help':
                return SettingsHelp();
            }
          },
        );
      },
    );
  }
}