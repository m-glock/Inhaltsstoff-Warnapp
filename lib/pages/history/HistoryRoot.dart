import '../../backend/Enums/ScanResult.dart';
import '../../customWidgets/ProductListItem.dart';
import '../../customWidgets/CustomAppBar.dart';
import 'package:flutter/material.dart';

class HistoryRoot extends StatelessWidget {
  const HistoryRoot({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Verlauf'),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: <Widget>[
          ProductListItem(
            image: NetworkImage('https://googleflutter.com/sample_image.jpg'),
            name: 'Produkt 1',
            scanDate: DateTime.now(),
            scanResult: ScanResult.Green,
          ),
          ProductListItem(
            image: null,
            name: 'Produkt 2',
            scanDate: DateTime.now(),
            scanResult: ScanResult.Yellow,
          )
        ],
      ),
    );
  }
}
