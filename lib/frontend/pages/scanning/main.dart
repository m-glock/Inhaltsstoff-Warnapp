import 'package:flutter/material.dart';

import './ScanningCropImagePage.dart';
import './ScanningCameraPage.dart';
import './ScanningResultPage.dart';
import './ScanningRootPage.dart';

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
                return ScanningRootPage();
              case '/camera':
                return ScanningCamera();  
              case '/crop_image':
                return ScanningCropImage(settings.arguments);
              case '/result':
                return ScanningResultPage(settings.arguments);
              default: return ScanningRootPage();
            }
          },
        );
      },
    );
  }
}
