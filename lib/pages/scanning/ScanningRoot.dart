import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../customWidgets/CustomAppBar.dart';
import '../../customWidgets/LabelledIconButton.dart';
import './ScanningBarcodeDialog.dart';

class ScanningRoot extends StatefulWidget {
  const ScanningRoot({Key key}) : super(key: key);

  @override
  _ScanningRootState createState() => _ScanningRootState();
}

class _ScanningRootState extends State<ScanningRoot> {
  String _scanBarcode = '';

  _getHexPrimaryColor() {
    return '#${Theme.of(context).primaryColor.red.toRadixString(16)}${Theme.of(context).primaryColor.green.toRadixString(16)}${Theme.of(context).primaryColor.blue.toRadixString(16)}';
  }

  _startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            _getHexPrimaryColor(), "Abbrechen", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          _getHexPrimaryColor(), "Abbrechen", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Scanning'),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Text(
              'Scanne dein Produkt',
              style: Theme.of(context).textTheme.headline1,
            ),
            Expanded(
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LabelledIconButton(
                  'Manuelle Eingabe',
                  Icons.text_fields,
                  false,
                  () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return ScanningBarcodeDialog(
                          () {
                            Navigator.pop(context);
                          },
                          (String value) {
                            setState(() {
                              _scanBarcode = value;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
                LabelledIconButton(
                  'Barcode scannen',
                  Icons.fullscreen,
                  true,
                  _scanBarcodeNormal,
                  iconSize: 52,
                ),
                LabelledIconButton(
                  'Text scannen',
                  Icons.image,
                  false,
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
