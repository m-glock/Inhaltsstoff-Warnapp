import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../customWidgets/CustomAppBar.dart';

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
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 20.0),
            Expanded(
                child: Image.asset(
                  'assets/images/logo2.png',
                  height: 300,
                  width: 300,
                ),
                flex: 1),
            SizedBox(height: 20.0),
            // Text('$_scanBarcode',
            //     style: Theme.of(context).textTheme.headline2,
            //     textAlign: TextAlign.center),
            // SizedBox(height: 20.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  Column(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Barcode manuell eingeben"),
                                content: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(13),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.dialpad, color: Colors.grey),
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Abbrechen"),
                                    onPressed: () {
                                      Navigator.pop(
                                          context, _textController.text);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      if (_textController.text.length != 13) {
                                        return;
                                      } else {
                                        Navigator.pop(
                                            context, _textController.text);
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          ).then((val) {
                            setState(() {
                              _scanBarcode = val;
                            });
                          });
                        },
                        color: Theme.of(context).primaryColorLight,
                        textColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.text_fields,
                          size: 24,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text('Manuelle Eingabe',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .fontSize)),
                    ],
                  ),
                  Column(
                    children: [
                      RaisedButton(
                        onPressed: () => scanBarcodeNormal(),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.fullscreen,
                          size: 50,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                      ),
                      SizedBox(height: 10.0),
                      Text('Barcode scannen',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .fontSize)),
                    ],
                  ),
                  Column(
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        color: Theme.of(context).primaryColorLight,
                        textColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.image,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.5
                            )
                            ),
                      ),
                      SizedBox(height: 10.0),
                      Text('Text scannen',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .fontSize)),
                    ],
                  ),
                ]),
            SizedBox(height: 30.0),
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
