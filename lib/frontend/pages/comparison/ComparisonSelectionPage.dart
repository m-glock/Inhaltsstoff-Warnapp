import 'package:flutter/material.dart';

import '../../../backend/databaseEntities/Product.dart';
import '../scanning/ScanningResultPage.dart';
import './comparisonCustomWidgets/ComparisonSelectedProductCard.dart';
import './comparisonCustomWidgets/ComparisonSelectProductButtons.dart';

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
                  child: _productOne != null
                      ? Column(
                          children: [
                            ComparisonSelectedProductCard(
                              productNumber: 1,
                              productName: _productOne.name,
                              scanDate: _productOne.scanDate,
                              useScanResultSpecificBackgroundColor: false,
                              showInfoButton: true,
                              onInfoButtonPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ScanningResultPage(_productOne),
                                  ),
                                );
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Anderes Produkt wählen',
                                style: Theme.of(context).textTheme.button.merge(
                                      new TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                setState(() {
                                  _productOne = null;
                                });
                              },
                            ),
                          ],
                        )
                      : ComparisonSelectProductButtons(
                          onProductSelected: (product) {
                            setState(() {
                              _productOne = product;
                            });
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
                  child: _productTwo != null
                      ? Column(
                          children: [
                            ComparisonSelectedProductCard(
                              productNumber: 2,
                              productName: _productTwo.name,
                              scanDate: _productTwo.scanDate,
                              useScanResultSpecificBackgroundColor: false,
                              showInfoButton: true,
                              onInfoButtonPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ScanningResultPage(_productTwo),
                                  ),
                                );
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Anderes Produkt wählen',
                                style: Theme.of(context).textTheme.button.merge(
                                      new TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                setState(() {
                                  _productTwo = null;
                                });
                              },
                            ),
                          ],
                        )
                      : ComparisonSelectProductButtons(
                          onProductSelected: (product) {
                            setState(() {
                              _productTwo = product;
                            });
                          },
                        ),
                ),
              ],
            ),
          ),
          if (_productOne != null && _productTwo != null)
            RaisedButton(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(12),
              child: Text(
                'Vergleichen',
                style: Theme.of(context).textTheme.button.merge(
                      new TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                widget.onSelectedProducts(_productOne, _productTwo);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
        ],
      ),
    );
  }
}
