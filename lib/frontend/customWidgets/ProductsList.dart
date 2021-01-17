import 'package:flutter/material.dart';

import '../../backend/Product.dart';
import './ProductListItem.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({
    Key key,
    this.products,
    this.listEmptyText,
    this.onProductSelected,
    this.productsRemovable,
    this.onProductRemove
  }) : super(key: key);

  final List<Product> products;
  final String listEmptyText;
  final Function(Product) onProductSelected;
  final bool productsRemovable;
  final Function(Product) onProductRemove;

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
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
            children: products
                .map((product) => ProductListItem(
                      image: product.imageUrl != null
                          ? NetworkImage(product.imageUrl)
                          : null,
                      name: product.name,
                      scanDate: product.scanDate,
                      scanResult: product.scanResult,
                      onProductSelected: () {
                        onProductSelected(product);
                      },
                      removable: productsRemovable,
                      onRemove: () {
                        onProductRemove(product);
                      },
                    ))
                .toList(),
          );
  }
}
