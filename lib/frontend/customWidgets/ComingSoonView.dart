import 'package:flutter/material.dart';

class ComingSoonView extends StatelessWidget {
  ComingSoonView({
    Key key,
    this.teaser,
  }) : super(key: key);

  final String teaser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/undraw_in_progress.png',
          ),
          Text(
            'Coming soon',
            style: Theme
                .of(context)
                .textTheme
                .headline1,
            textAlign: TextAlign.center,
          ),
          Text(
            teaser,
            style: Theme
                .of(context)
                .textTheme
                .bodyText1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}