import 'package:Inhaltsstoff_Warnapp/backend/ScanResult.dart';
import 'package:flutter/material.dart';

class ScanningResultText extends StatelessWidget {
  ScanningResultText({Key key, this.result}) : super(key: key);

  ScanResult result;
  String _text;
  Color _color;

  @override
  Widget build(BuildContext context) {
    switch (result) {
      case ScanResult.OKAY:
        _text = 'Gute Wahl!';
        _color = Colors.green;
        break;
      case ScanResult.CRITICAL:
        _text = 'Achtung!';
        _color = Colors.yellow[800];
        break;
      case ScanResult.NOT_OKAY:
        _text = 'Schlechte Wahl!';
        _color = Colors.red;
        break;
    }
    return Text(
      _text,
      style: TextStyle(
        color: _color,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
