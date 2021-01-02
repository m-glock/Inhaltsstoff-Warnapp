import '../../backend/Enums/ScanResult.dart';
import '../../backend/Product.dart';
import '../../customWidgets/ProductListItem.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class HistoryRoot extends StatelessWidget {
  HistoryRoot({Key key}) : super(key: key);

  List<Product> _scannedProducts;

  @override
  Widget build(BuildContext context) {
    _scannedProducts = getScannedProductsList();
    return Scaffold(
      appBar: CustomAppBar('Verlauf'),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: _scannedProducts
            .map((product) => ProductListItem(
                  image: NetworkImage(product.imageUrl),
                  name: product.name,
                  scanDate: product.scanDate,
                  scanResult: ScanResult.Green,
                  //product.scanResult,
                  onProductSelected: () {
                    Navigator.pushNamed(context, '/product', arguments: product);
                  },
                ))
            .toList(),
        /*<Widget>[
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
            onProductSelected: () {},
          )
        ],*/
      ),
    );
  }

  List<Product> getScannedProductsList() {
    //TODO: get list from backend
    return [
      new Product('Produkt 1', 'https://googleflutter.com/sample_image.jpg',
          '4009077020122', DateTime.now()),
      new Product('Produkt 2', 'https://googleflutter.com/sample_image.jpg',
          '9001400005030', DateTime.now()),
    ];
  }
}
