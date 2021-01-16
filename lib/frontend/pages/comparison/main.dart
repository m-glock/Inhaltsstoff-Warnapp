import 'package:flutter/material.dart';

import './ComparisonRootPage.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({Key key}) : super(key: key);

  @override
  _ComparisonPageState createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return ComparisonRootPage();
              // for every other comparison page not named routes have to be used
            // in order that the comparison navigation also works in case
            // it was started by the comparison button on the scanning result page
            // which is reachable not only from the scanning section,
            // but also from the lists history and favourites
            }
          },
        );
      },
    );
  }
}
