import 'package:flutter/material.dart';

import './AnalysisRootPage.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key key}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return AnalysisRootPage();
            }
          },
        );
      },
    );
  }
}
