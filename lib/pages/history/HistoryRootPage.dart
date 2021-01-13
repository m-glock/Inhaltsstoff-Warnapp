import '../../backend/Enums/ScanResult.dart';
import '../../backend/Product.dart';
import '../../customWidgets/ProductListItem.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class HistoryRootPage extends StatelessWidget {
  HistoryRootPage({Key key}) : super(key: key);

  List<Product> _scannedProducts;

  @override
  Widget build(BuildContext context) {
    _scannedProducts = getScannedProductsList();
    return Scaffold(
      appBar: CustomAppBar('Verlauf'),
      backgroundColor: Colors.white,
      body: _scannedProducts == null || _scannedProducts.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  'Du hast noch keine Produkte eingescannt.',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              children: _scannedProducts
                  .map((product) => ProductListItem(
                        image: NetworkImage(product.imageUrl),
                        name: product.name,
                        scanDate: product.scanDate,
                        scanResult: ScanResult.Green,
                        //product.scanResult,
                        onProductSelected: () {
                          Navigator.pushNamed(context, '/product',
                              arguments: product);
                        },
                      ))
                  .toList(),
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
    //return [];
  }
}
