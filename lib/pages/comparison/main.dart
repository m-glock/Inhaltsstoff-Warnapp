import 'package:flutter/material.dart';
import 'ComparisonRoot.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({ Key key }) : super(key: key);

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
            switch(settings.name) {
              case '/':
                return ComparisonRoot();
              case '/comparison_view':
            }
          },
        );
      },
    );
  }
}