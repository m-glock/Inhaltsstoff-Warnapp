import 'package:Essbar/backend/Enums/ScanResult.dart';

import '../../../backend/ListManager.dart';
import '../../../backend/Product.dart';
import '../../customWidgets/ProductListItem.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class FavouritesRootPage extends StatefulWidget {
  FavouritesRootPage({Key key}) : super(key: key);

  @override
  _FavouritesRootPageState createState() => _FavouritesRootPageState();
}

class _FavouritesRootPageState extends State<FavouritesRootPage> {
  List<Product> _favouriteProducts;
  Map<Product, ScanResult> _productsScanResults;

  @override
  void initState() {
    super.initState();
    _getFavouriteProducts();
    _addOnListUpdateListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Favoriten'),
      backgroundColor: Colors.white,
      body: _favouriteProducts == null || _productsScanResults == null
          ? CircularProgressIndicator()
          : _favouriteProducts.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Text(
                      'Du hast keine Favoriten gespeichert.',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  children: _favouriteProducts
                      .map((product) => ProductListItem(
                            image: product.imageUrl != null
                                ? NetworkImage(product.imageUrl)
                                : null,
                            name: product.name,
                            scanDate: product.scanDate,
                            scanResult: _productsScanResults[product],
                            onProductSelected: () {
                              Navigator.pushNamed(context, '/product',
                                  arguments: product);
                            },
                            removable: true,
                            onRemove: () {
                              _removeFavourite(product);
                            },
                          ))
                      .toList(),
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _removeOnListUpdateListener();
  }

  void _getFavouriteProducts() async {
    var favouritesList = await ListManager.instance.favouritesList;
    List<Product> favouriteProducts = favouritesList.getProducts();
    Map<Product, ScanResult> productsResults = {
      for (Product p in favouriteProducts) p: await p.getScanResult()
    };

    setState(() {
      _favouriteProducts = favouritesList.getProducts();
      _productsScanResults = productsResults;
    });
  }

  void _addOnListUpdateListener() async {
    var favouritesList = await ListManager.instance.favouritesList;
    favouritesList.onUpdate.subscribe((args) {
      _getFavouriteProducts();
    });
  }

  void _removeOnListUpdateListener() async {
    var favouritesList = await ListManager.instance.favouritesList;
    favouritesList.onUpdate.unsubscribe((args) {
      _getFavouriteProducts();
    });
  }

  void _removeFavourite(Product product) async {
    var favouritesList = await ListManager.instance.favouritesList;
    favouritesList.removeProduct(product);
    setState(() {
      _favouriteProducts.remove(product);
    });
  }
}
