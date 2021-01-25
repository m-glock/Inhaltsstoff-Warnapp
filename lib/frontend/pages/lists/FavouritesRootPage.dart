import '../../../backend/Enums/ScanResult.dart';
import '../../../backend/ListManager.dart';
import '../../../backend/Product.dart';
import '../../customWidgets/ProductsList.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class FavouritesRootPage extends StatefulWidget {
  FavouritesRootPage({Key key}) : super(key: key);

  @override
  _FavouritesRootPageState createState() => _FavouritesRootPageState();
}

class _FavouritesRootPageState extends State<FavouritesRootPage> {
  Map<Product, ScanResult> _favouriteProductsAndResults;

  @override
  void initState() {
    super.initState();
    _getFavouriteProductsAndResults();
    _addOnListUpdateListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Favoriten'),
      backgroundColor: Colors.white,
      body: _favouriteProductsAndResults == null
          ? CircularProgressIndicator()
          : ProductsList(
              productsAndResults: _favouriteProductsAndResults,
              listEmptyText: 'Du hast keine Favoriten gespeichert.',
              onProductSelected: (product) {
                Navigator.pushNamed(context, '/product', arguments: product);
              },
              productsRemovable: true,
              onProductRemove: (product) {
                _removeFavourite(product);
              },
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _removeOnListUpdateListener();
  }

  void _getFavouriteProductsAndResults() async {
    var favouritesList = await ListManager.instance.favouritesList;
    List<Product> favouriteProducts = favouritesList.getProducts();
    Map<Product, ScanResult> productsResults = {
      for (Product p in favouriteProducts) p: await p.getScanResult()
    };
    setState(() {
      _favouriteProductsAndResults = productsResults;
    });
  }

  void _addOnListUpdateListener() async {
    var favouritesList = await ListManager.instance.favouritesList;
    favouritesList.onUpdate.subscribe((args) {
      _getFavouriteProductsAndResults();
    });
  }

  void _removeOnListUpdateListener() async {
    var favouritesList = await ListManager.instance.favouritesList;
    favouritesList.onUpdate.unsubscribe((args) {
      _getFavouriteProductsAndResults();
    });
  }

  void _removeFavourite(Product product) async {
    var favouritesList = await ListManager.instance.favouritesList;
    favouritesList.removeProduct(product);
    setState(() {
      _favouriteProductsAndResults.remove(product);
    });
  }
}
