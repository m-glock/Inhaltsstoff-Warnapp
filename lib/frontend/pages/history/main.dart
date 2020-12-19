import 'package:flutter/material.dart';
import 'HistoryRootPage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({ Key key }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return HistoryRootPage();
            }
          },
        );
      },
    );
  }
}