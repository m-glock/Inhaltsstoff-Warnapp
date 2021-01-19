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
  List<Product> _favouriteProducts;

  @override
  void initState() {
    super.initState();
    _getFavouriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Wähle ein Produkt'),
      backgroundColor: Colors.white,
      body: _favouriteProducts == null
          ? CircularProgressIndicator()
          : ProductsList(
              products: _favouriteProducts,
              listEmptyText: 'Du hast keine Favoriten gespeichert.',
              onProductSelected: widget.onProductSelected,
              productsRemovable: false,
            ),
    );
  }

  void _getFavouriteProducts() async {
    var favouritesList = await ListManager.instance.favouritesList;
    setState(() {
      _favouriteProducts = favouritesList.getProducts();
    });
  }
}
