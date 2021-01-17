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
  List<Product> _favouriteProducts;

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
      body: _favouriteProducts == null
          ? CircularProgressIndicator()
          : ProductsList(
              products: _favouriteProducts,
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

  void _getFavouriteProducts() async {
    var favouritesList = await ListManager.instance.favouritesList;
    setState(() {
      _favouriteProducts = favouritesList.getProducts();
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
