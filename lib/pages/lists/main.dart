import 'package:flutter/material.dart';
import 'FavouritesRoot.dart';
import 'FavouritesSecond.dart';

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
                return FavouritesRoot();
              case '/second':
                return FavouritesSecond();
            }
          },
        );
      },
    );
  }
}