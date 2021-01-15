import 'package:flutter/material.dart';

class LabelledIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final double iconSize;
  final Function onPressed;

  LabelledIconButton({
    Key key,
    this.label,
    this.icon,
    this.isPrimary,
    this.onPressed,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          onPressed: onPressed,
          color: isPrimary
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
          textColor: isPrimary
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).primaryColor,
          child: Icon(
            icon,
            size: iconSize,
          ),
          padding: EdgeInsets.all(16),
          shape: !isPrimary
              ? CircleBorder(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                )
              : CircleBorder(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyText2.merge(
                  TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
