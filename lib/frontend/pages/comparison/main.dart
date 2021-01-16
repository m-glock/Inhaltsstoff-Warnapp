import 'package:flutter/material.dart';

import '../scanning/ScanningResultPage.dart';
import '../scanning/ScanningRootPage.dart';
import './ComparisonRootPage.dart';

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
              //case '/comparison_view':
              case '/product':
                return ScanningResultPage(settings.arguments);
              case '/scanning':
                return ScanningRootPage(onFetchedProduct: settings.arguments);
            }
          },
        );
      },
    );
  }
}