import 'package:flutter/material.dart';

class OnboardingTitleWidget extends StatelessWidget {
  OnboardingTitleWidget({this.title, this.subTitle});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(children: [
            Padding(
              child: Text(
                title,
                style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.only(bottom: 8.0),
            ),
            Text(
              subTitle,
              style: TextStyle(fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue[50],
      ),
    );
  }
}
