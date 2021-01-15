import 'package:Inhaltsstoff_Warnapp/frontend/pages/scanning/ScanningResultPage.dart';
import 'package:flutter/material.dart';
import './FavouritesRootPage.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({ Key key }) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return FavouritesRootPage();
              case '/product':
                return ScanningResultPage(settings.arguments);
            }
          },
        );
      },
    );
  }
}