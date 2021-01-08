import 'package:flutter/material.dart';

class ScanningInfoLine extends StatelessWidget {
  const ScanningInfoLine(
      {Key key, this.backgroundColor, this.textColor, this.icon, this.text})
      : super(key: key);

  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(text, style: TextStyle(fontSize: 14, color: textColor)),
        dense: true,
      ),
    );
  }
}
