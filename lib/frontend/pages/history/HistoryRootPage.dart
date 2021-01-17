import '../../../backend/ListManager.dart';
import '../../../backend/Product.dart';
import '../../customWidgets/ProductListItem.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class HistoryRootPage extends StatefulWidget {
  HistoryRootPage({Key key}) : super(key: key);

  @override
  _HistoryRootPageState createState() => _HistoryRootPageState();
}

class _HistoryRootPageState extends State<HistoryRootPage> {
  List<Product> _scannedProducts;

  @override
  void initState() {
    super.initState();
    _getScannedProducts();
    _addOnListUpdateListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Verlauf'),
      backgroundColor: Colors.white,
      body: _scannedProducts == null
          ? CircularProgressIndicator()
          : _scannedProducts.isEmpty
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
                            image: product.imageUrl != null
                                ? NetworkImage(product.imageUrl)
                                : null,
                            name: product.name,
                            scanDate: product.scanDate,
                            scanResult: product.scanResult,
                            onProductSelected: () {
                              Navigator.pushNamed(context, '/product',
                                  arguments: product);
                            },
                            removable: false,
                          ))
                      .toList(),
                ),
      floatingActionButton:
          _scannedProducts != null && _scannedProducts.isNotEmpty
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

  void _getScannedProducts() async {
    var history = await ListManager.instance.history;
    setState(() {
      _scannedProducts = history.getProducts();
    });
  }

  void _addOnListUpdateListener() async {
    var history = await ListManager.instance.history;
    history.onUpdate.subscribe((args) {
      _getScannedProducts();
    });
  }

  void _removeOnListUpdateListener() async {
    var history = await ListManager.instance.history;
    history.onUpdate.unsubscribe((args) {
      _getScannedProducts();
    });
  }

  void _clearHistory() async {
    var history = await ListManager.instance.history;
    history.clearHistory();
    setState(() {
      _scannedProducts.clear();
    });
  }
}
