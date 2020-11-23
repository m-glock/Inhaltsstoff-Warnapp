import 'package:Inhaltsstoff_Warnapp/pages/HomePage.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: RaisedButton(
        child: Text("Finish Onboarding"),
        onPressed: () => _onIntroEnd(context),
      ),
    ));
  }
}
