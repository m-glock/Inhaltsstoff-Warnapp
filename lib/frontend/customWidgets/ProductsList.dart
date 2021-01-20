import 'package:flutter/material.dart';

import '../../backend/Enums/ScanResult.dart';
import '../../backend/Product.dart';
import './ProductListItem.dart';

class ProductsList extends StatefulWidget {
  const ProductsList(
      {Key key,
      this.products,
      this.listEmptyText,
      this.onProductSelected,
      this.productsRemovable,
      this.onProductRemove})
      : super(key: key);

  final List<Product> products;
  final String listEmptyText;
  final Function(Product) onProductSelected;
  final bool productsRemovable;
  final Function(Product) onProductRemove;

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  Map<Product, ScanResult> _productsScanResults;

  @override
  void initState() {
    super.initState();
    _getProductsScanResults();
  }

  @override
  Widget build(BuildContext context) {
    return widget.products.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                widget.listEmptyText,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : _productsScanResults == null
            ? CircularProgressIndicator()
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                children: widget.products
                    .map((product) => ProductListItem(
                          image: product.imageUrl != null
                              ? NetworkImage(product.imageUrl)
                              : null,
                          name: product.name,
                          scanDate: product.scanDate,
                          scanResult: _productsScanResults[product],
                          onProductSelected: () {
                            widget.onProductSelected(product);
                          },
                          removable: widget.productsRemovable,
                          onRemove: () {
                            widget.onProductRemove(product);
                          },
                        ))
                    .toList(),
              );
  }

  _getProductsScanResults() async {
    Map<Product, ScanResult> productsResults = {
      for (Product p in widget.products) p: await p.getScanResult()
    };
    setState(() {
      _productsScanResults = productsResults;
    });
  }
}
