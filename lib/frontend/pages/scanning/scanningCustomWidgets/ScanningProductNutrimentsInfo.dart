import 'package:flutter/material.dart';

import './ScanningInfoLine.dart';

class ScanningProductNutrimentsInfo extends StatelessWidget {
  ScanningProductNutrimentsInfo({Key key, this.nutriments}) : super(key: key);

  final List<String> nutriments;

  @override
  Widget build(BuildContext context) {
    return ScanningInfoLine(
      backgroundColor:
          nutriments.isEmpty ? Colors.grey[200] : Colors.green[100],
      textColor: nutriments.isEmpty ? Colors.grey[600] : Colors.green[800],
      icon: nutriments.isEmpty ? Icons.remove : Icons.add,
      text: nutriments.isEmpty
          ? 'Enthält keinen deiner gewünschten Nährstoffe'
          : 'Enthält ' +
              nutriments.reduce((value, element) => value + ', ' + element),
    );
  }
}
