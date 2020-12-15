import 'package:Inhaltsstoff_Warnapp/backend/ScanResult.dart';
import 'package:flutter/material.dart';

import 'ScanningInfoLine.dart';

class ScanningResultExplanation extends StatelessWidget {
  ScanningResultExplanation(
      {Key key, this.result, this.unwantedIngredients})
      : super(key: key);

  final ScanResult result;
  final List<String> unwantedIngredients;
  IconData _icon;
  String _text;
  Color _backgroundColor;
  Color _textColor;

  @override
  Widget build(BuildContext context) {
    switch (result) {
      case ScanResult.OKAY:
        _icon = Icons.done;
        _text = 'Enthält keine ungewollten Inhaltsstoffe';
        _backgroundColor = Colors.green[100];
        _textColor = Colors.green[800];
        break;
      case ScanResult.CRITICAL:
        _icon = Icons.warning;
        _text = 'Enthält ' +
            unwantedIngredients
                .reduce((value, element) => value + ', ' + element);
        _backgroundColor = Colors.yellow[100];
        _textColor = Colors.yellow[900];
        break;
      case ScanResult.NOT_OKAY:
        _icon = Icons.clear;
        _text = 'Enthält ' +
            unwantedIngredients
                .reduce((value, element) => value + ', ' + element);
        _backgroundColor = Colors.red[100];
        _textColor = Colors.red;
        break;
    }
    return ScanningInfoLine(
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      icon: _icon,
      text: _text,
    );
  }
}