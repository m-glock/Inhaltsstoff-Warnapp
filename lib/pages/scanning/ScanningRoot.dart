import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:Inhaltsstoff_Warnapp/theme/style.dart';

class ScanningRoot extends StatefulWidget {
  const ScanningRoot({ Key key }) : super(key: key);

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
      text: "Scanne den gewünschten Artikel",
    );
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Abbrechen", true, ScanMode.BARCODE)
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
      appBar: AppBar(
        title: Text('Barcode Scanner'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
    body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
                                Image.asset('assets/images/logo.png'),
            SizedBox(height:60.0),
            Text('Scanne dein Produkt', style: appTheme().textTheme.headline1, textAlign: TextAlign.center),
            SizedBox(height:20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: appTheme().primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.text_fields,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    SizedBox(height:10.0),
                    Text('Manuelle Eingabe', style: TextStyle(color: appTheme().primaryColor, fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () => scanBarcodeNormal(),
                      color: appTheme().primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 96,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    SizedBox(height:10.0),
                    Text('$_scanBarcode', style: TextStyle(color: appTheme().primaryColor, fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: appTheme().primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.image,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    SizedBox(height:10.0),
                    Text('Text scannen', style: TextStyle(color: appTheme().primaryColor, fontSize: 14)),
                  ],
                ),
              ]
            ),
          SizedBox(height:30.0),
          ],
        ),
    );
  }
 
 
//  children: <Widget>[
//                         TextField(controller: _textController),
//                         RaisedButton(
//                             onPressed: () => scanBarcodeNormal(),
//                             child: Text("Barcode scan")),
//                         RaisedButton(
//                             onPressed: () => startBarcodeScanStream(),
//                             child: Text("Barcode scan stream")),
//                         Text('Scan Ergebnis : $_scanBarcode\n',
//                             style: TextStyle(fontSize: 20))
//                       ]

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}