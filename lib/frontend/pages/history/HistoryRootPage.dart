import '../../../backend/Enums/ScanResult.dart';
import '../../../backend/ListManager.dart';
import '../../../backend/Product.dart';
import '../../customWidgets/ProductsList.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class HistoryRootPage extends StatefulWidget {
  HistoryRootPage({Key key}) : super(key: key);

  @override
  _HistoryRootPageState createState() => _HistoryRootPageState();
}

class _HistoryRootPageState extends State<HistoryRootPage> {
  Map<Product, ScanResult> _scannedProductsAndResults;

  @override
  void initState() {
    super.initState();
    _getScannedProductsAndResults();
    _addOnListUpdateListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Verlauf'),
      backgroundColor: Colors.white,
      body: _scannedProductsAndResults == null
          ? CircularProgressIndicator()
          : ProductsList(
              productsAndResults: _scannedProductsAndResults,
              listEmptyText: 'Du hast noch keine Produkte eingescannt.',
              onProductSelected: (product) {
                Navigator.pushNamed(context, '/product', arguments: product);
              },
              productsRemovable: false,
            ),
      floatingActionButton:
          _scannedProductsAndResults != null && _scannedProductsAndResults.isNotEmpty
              ? FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    _clearHistory();
                  },
                )
              : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _removeOnListUpdateListener();
  }

  void _getScannedProductsAndResults() async {
    var history = await ListManager.instance.history;
    List<Product> scannedProducts = history.getProducts();
    Map<Product, ScanResult> productsResults = {
      for (Product p in scannedProducts) p: await p.getScanResult()
    };
    setState(() {
      _scannedProductsAndResults = productsResults;
    });
  }

  void _addOnListUpdateListener() async {
    var history = await ListManager.instance.history;
    history.onUpdate.subscribe((args) {
      _getScannedProductsAndResults();
    });
  }

  void _removeOnListUpdateListener() async {
    var history = await ListManager.instance.history;
    history.onUpdate.unsubscribe((args) {
      _getScannedProductsAndResults();
    });
  }

  void _clearHistory() async {
    var history = await ListManager.instance.history;
    history.clearHistory();
    setState(() {
      _scannedProductsAndResults.clear();
    });
  }
}
