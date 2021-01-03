import 'package:flutter/material.dart';

import '../../backend/Product.dart';
import './comparisonCustomWidgets/ComparisonSelectProductButtons.dart';
import './comparisonCustomWidgets/ComparisonSelectedProductCard.dart';

class ComparisonSelectionPage extends StatefulWidget {
  const ComparisonSelectionPage({
    Key key,
    this.productOne,
    this.onSelectedProducts,
  }) : super(key: key);

  final Product productOne;
  final Function(Product, Product) onSelectedProducts;

  @override
  _ComparisonSelectionPageState createState() =>
      _ComparisonSelectionPageState();
}

class _ComparisonSelectionPageState extends State<ComparisonSelectionPage> {
  Product _productOne;
  Product _productTwo;

  @override
  void initState() {
    super.initState();
    _productOne = widget.productOne;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Vergleich',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              //horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Text(
              'Wähle zwei Produkte, die du vergleichen möchtest. Ein Produkt kann aus der Favoritenliste ausgewählt oder neu gescannt werden.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _productOne != null
                      ? ComparisonSelectedProductCard(
                          productNumber: 1,
                          productName: _productOne.name,
                          scanDate: _productOne.scanDate,
                          onInfoButtonPressed: () {},
                        )
                      : ComparisonSelectProductButtons(
                          onProductSelected: (product) {
                            setState(() {
                              _productOne = product;
                            });
                            if (_productOne != null && _productTwo != null)
                              widget.onSelectedProducts(
                                  _productOne, _productTwo);
                          },
                        ),
                ),
                Container(
                  height: 200.0,
                  // without this the vertical devider is not showing
                  child: VerticalDivider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1.5,
                    width: 30.0,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _productTwo != null
                      ? ComparisonSelectedProductCard(
                          productNumber: 2,
                          productName: _productTwo.name,
                          scanDate: _productTwo.scanDate,
                          onInfoButtonPressed: () {},
                        )
                      : ComparisonSelectProductButtons(
                          onProductSelected: (product) {
                            setState(() {
                              _productTwo = product;
                            });
                            if (_productOne != null && _productTwo != null)
                              widget.onSelectedProducts(
                                  _productOne, _productTwo);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
