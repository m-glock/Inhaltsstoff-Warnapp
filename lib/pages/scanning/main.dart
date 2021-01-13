import 'package:flutter/material.dart';

import './ScanningCropImage.dart';
import './ScanningCamera.dart';
import './ScanningResult.dart';
import './ScanningRoot.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({Key key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return ScanningRoot();
              case '/camera':
                return ScanningCamera();  
              case '/result':
                return ScanningResult(settings.arguments);
              //return ScanningResult(testProduct);
              default: return ScanningRoot();
            }
          },
        );
      },
    );
  }
}
