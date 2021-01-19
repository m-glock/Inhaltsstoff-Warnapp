import '../comparison/ComparisonRootPage.dart';
import 'package:flutter/material.dart';

import 'ScanningResultPage.dart';
import 'ScanningRootPage.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({Key key}) : super(key: key);

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
            switch (settings.name) {
              case '/':
                return ScanningRootPage();
              case '/result':
                return ScanningResultPage(settings.arguments);
            }
          },
        );
      },
    );
  }
}
