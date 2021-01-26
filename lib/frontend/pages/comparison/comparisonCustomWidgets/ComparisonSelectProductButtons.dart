import 'package:flutter/material.dart';

import '../../../../backend/databaseEntities/Product.dart';
import '../../scanning/ScanningRootPage.dart';
import '../ComparisonFavouritesListPage.dart';

class ComparisonSelectProductButtons extends StatelessWidget {
  const ComparisonSelectProductButtons({
    Key key,
    this.onProductSelected,
  }) : super(key: key);

  final Function(Product) onProductSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(12),
          child: Text(
            'Scannen',
            style: Theme.of(context).textTheme.button.merge(
                  new TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ScanningRootPage(
                  onFetchedProduct: (product) {
                    Navigator.pop(context);
                    onProductSelected(product);
                  },
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Text(
            'oder',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColorLight,
          padding: EdgeInsets.all(12),
          child: Text(
            'Auswählen aus Favoritenliste',
            style: Theme.of(context).textTheme.button.merge(
                  new TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ComparisonFavouritesListPage(
                  onProductSelected: (product) {
                    Navigator.pop(context);
                    onProductSelected(product);
                  },
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ],
    );
  }
}
