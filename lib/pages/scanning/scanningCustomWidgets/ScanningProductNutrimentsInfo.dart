import 'package:flutter/material.dart';

import 'ScanningInfoLine.dart';

class ScanningProductNutrimentsInfo extends StatelessWidget {
  ScanningProductNutrimentsInfo({Key key, this.nutriments})
      : super(key: key);

  final List<String> nutriments;
  IconData _icon;
  String _text;
  Color _backgroundColor;
  Color _textColor;


  @override
  Widget build(BuildContext context) {
    if (nutriments.isEmpty) {
      _icon = Icons.remove;
      _text = 'Enthält keinen deiner gewünschten Nährstoffe';
      _backgroundColor = Colors.grey[200];
      _textColor = Colors.grey[600];
    } else {
      _icon = Icons.add;
      _text = 'Enthält ' +
          nutriments.reduce((value, element) => value + ', ' + element);
      _backgroundColor = Colors.green[100];
      _textColor = Colors.green[800];
    }

    return ScanningInfoLine(
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      icon: _icon,
      text: _text,
    );
  }
}


