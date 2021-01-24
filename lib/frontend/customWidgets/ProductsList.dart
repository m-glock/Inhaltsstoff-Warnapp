import 'package:flutter/material.dart';

import '../../backend/Enums/ScanResult.dart';
import '../../backend/Product.dart';
import './ProductListItem.dart';

class ProductsList extends StatelessWidget {
  const ProductsList(
      {Key key,
      this.productsAndResults,
      this.listEmptyText,
      this.onProductSelected,
      this.productsRemovable,
      this.onProductRemove})
      : super(key: key);

  final Map<Product, ScanResult> productsAndResults;
  final String listEmptyText;
  final Function(Product) onProductSelected;
  final bool productsRemovable;
  final Function(Product) onProductRemove;

  @override
  Widget build(BuildContext context) {
    return productsAndResults.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                listEmptyText,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            children: productsAndResults.entries.map((productAndResult) {
              Product product = productAndResult.key;
              ScanResult result = productAndResult.value;
              return ProductListItem(
                image: product.imageUrl != null
                    ? NetworkImage(product.imageUrl)
                    : null,
                name: product.name,
                scanDate: product.scanDate,
                scanResult: result,
                onProductSelected: () {
                  onProductSelected(product);
                },
                removable: productsRemovable,
                onRemove: () {
                  onProductRemove(product);
                },
              );
            }).toList(),
          );
  }
}
