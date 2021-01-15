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

  @override
  void initState() {
    super.initState();
    _favouriteProducts = ListManager.instance.favouriteList.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Favoriten'),
      backgroundColor: Colors.white,
      body: _favouriteProducts == null || _favouriteProducts.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  'Du hast noch keine Favoriten gespeichert.',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              children: _favouriteProducts
                  .map((product) => ProductListItem(
                        image: NetworkImage(product.imageUrl),
                        name: product.name,
                        scanDate: product.scanDate,
                        scanResult: product.scanResult,
                        onProductSelected: () {
                          Navigator.pushNamed(context, '/product',
                              arguments: product);
                        },
                        removable: true,
                        onRemove: () {
                          ListManager.instance.favouriteList
                              .removeProduct(product);
                          setState(() {
                            _favouriteProducts.remove(product);
                          });
                        },
                      ))
                  .toList(),
            ),
    );
  }
}
