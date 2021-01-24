import 'package:flutter/material.dart';

import '../../backend/database/DatabaseHelper.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  waitforDatabaseBeforeRouting() async {
    List<Map<String, dynamic>> map = await DatabaseHelper.instance
        .customQuery('SELECT * FROM metadataFlags WHERE name = \'Onboarding\'');
    int isOnboardingDone = map[0]['isInitialized'] as int;
    if (isOnboardingDone == 0) {
      await DatabaseHelper.instance.customQuery(
          'UPDATE metadataFlags SET isInitialized=1 WHERE name = \'Onboarding\'');
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    waitforDatabaseBeforeRouting();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            child: Text(
              "Essbar",
              style: Theme.of(context).textTheme.headline1.merge(
                    TextStyle(
                      fontSize: 44.0,
                    ),
                  ),
            ),
            padding: EdgeInsets.all(12.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 100.0,
              vertical: 12.0,
            ),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          Padding(
            child: Text(
                "Wir bereiten alles für dich vor. Bitte habe einen Moment Geduld!",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center),
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 60.0),
          ),
          CircularProgressIndicator(
            backgroundColor: Theme.of(context).accentColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
