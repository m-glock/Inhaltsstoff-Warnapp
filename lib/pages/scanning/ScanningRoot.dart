import 'dart:async';
import 'package:Inhaltsstoff_Warnapp/customWidgets/LabelledIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../customWidgets/CustomAppBar.dart';
import './ScanningBarcodeDialog.dart';

class ScanningRoot extends StatefulWidget {
  const ScanningRoot({Key key}) : super(key: key);

  @override
  _ScanningRootState createState() => _ScanningRootState();
}

class _ScanningRootState extends State<ScanningRoot> {
  String _scanBarcode = '';
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: null,
    );
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            Theme.of(context).textTheme.button.color.toString(),
            "Abbrechen",
            true,
            ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Abbrechen", true, ScanMode.BARCODE);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Scanne dein Produkt',
              style: Theme.of(context).textTheme.headline1,
            ),
            Expanded(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 300,
                  width: 300,
                ),
                flex: 1),
            // Text('$_scanBarcode',
            //     style: Theme.of(context).textTheme.headline2,
            //     textAlign: TextAlign.center),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                verticalDirection: VerticalDirection.up,
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
                          return ScanningBarcodeDialog();
                        },
                      ).then((val) {
                        setState(() {
                          _scanBarcode = val;
                        });
                      });
                    },
                  ),
                  LabelledIconButton(
                    'Barcode scannen',
                    Icons.fullscreen,
                    true,
                    scanBarcodeNormal,
                    iconSize: 52,
                  ),
                  LabelledIconButton(
                    'Text scannen',
                    Icons.image,
                    false,
                    () {},
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
