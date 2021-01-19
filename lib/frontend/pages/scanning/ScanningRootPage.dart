import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../backend/FoodApiAccess.dart';
import '../../../backend/Product.dart';
import '../../customWidgets/CustomAppBar.dart';
import '../../customWidgets/LabelledIconButton.dart';
import 'scanningCustomWidgets/ScanningBarcodeDialog.dart';

class ScanningRootPage extends StatefulWidget {
  ScanningRootPage({Key key, this.onFetchedProduct}) : super(key: key);

  Function(Product) onFetchedProduct;

  @override
  _ScanningRootPageState createState() => _ScanningRootPageState();
}

class _ScanningRootPageState extends State<ScanningRootPage> {
  bool _isLoading = false;

  _getHexPrimaryColor() {
    return '#${Theme.of(context).primaryColor.red.toRadixString(16)}${Theme.of(context).primaryColor.green.toRadixString(16)}${Theme.of(context).primaryColor.blue.toRadixString(16)}';
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

    fetchProduct(barcodeScanRes);
  }

  Future<void> fetchProduct(String barcode) async {
    setState(() {
      _isLoading = true;
    });
    //var product = await FoodApiAccess.scanProduct('4009077020122');
    Product product = await FoodApiAccess.instance.scanProduct(barcode);
    setState(() {
      _isLoading = false;
    });
    widget.onFetchedProduct != null
        ? widget.onFetchedProduct(product)
        : Navigator.pushNamed(context, '/result', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Scannen'),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
                        label: 'Manuelle Eingabe',
                        icon: Icons.text_fields,
                        isPrimary: false,
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return ScanningBarcodeDialog(
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onSubmit: (String value) {
                                  Navigator.pop(context);
                                  fetchProduct(value);
                                },
                              );
                            },
                          );
                        },
                      ),
                      LabelledIconButton(
                        label: 'Barcode scannen',
                        icon: Icons.fullscreen,
                        isPrimary: true,
                        onPressed: _scanBarcodeNormal,
                        iconSize: 52,
                      ),
                      LabelledIconButton(
                        label: 'Text scannen',
                        icon: Icons.image,
                        isPrimary: false,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
