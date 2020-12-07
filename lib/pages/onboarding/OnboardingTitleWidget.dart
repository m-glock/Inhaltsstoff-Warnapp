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
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1.merge(
                      TextStyle(
                        color: Colors.white,
                      ),
                    ),
              ),
              padding: EdgeInsets.only(bottom: 8.0),
            ),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.bodyText1.merge(
                    TextStyle(
                      color: Colors.white,
                    ),
                  ),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
