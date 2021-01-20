import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String headline;
  final String content;
  final Function onDismiss;

  const CustomAlertDialog({
    Key key,
    this.headline,
    this.content,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        headline,
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: onDismiss,
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColorLight,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
      actionsPadding: EdgeInsets.only(
        right: 16.0,
        bottom: 12.0,
      ),
    );
  }
}
