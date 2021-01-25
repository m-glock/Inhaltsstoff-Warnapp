import '../../../backend/Enums/ScanResult.dart';
import '../../../backend/ListManager.dart';
import '../../../backend/Product.dart';
import '../../customWidgets/ProductsList.dart';
import '../../customWidgets/CustomAppBar.dart';

import 'package:flutter/material.dart';

class ComparisonFavouritesListPage extends StatefulWidget {
  ComparisonFavouritesListPage({
    Key key,
    this.onProductSelected,
  }) : super(key: key);

  final Function(Product) onProductSelected;

  @override
  _ComparisonFavouritesListPageState createState() =>
      _ComparisonFavouritesListPageState();
}

class _ComparisonFavouritesListPageState
    extends State<ComparisonFavouritesListPage> {
  Map<Product, ScanResult> _favouriteProductsAndResults;

  @override
  void initState() {
    super.initState();
    _getFavouriteProductsAndResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Wähle ein Produkt'),
      backgroundColor: Colors.white,
      body: _favouriteProductsAndResults == null
          ? CircularProgressIndicator()
          : ProductsList(
              productsAndResults: _favouriteProductsAndResults,
              listEmptyText: 'Du hast keine Favoriten gespeichert.',
              onProductSelected: widget.onProductSelected,
              productsRemovable: false,
            ),
    );
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
}
