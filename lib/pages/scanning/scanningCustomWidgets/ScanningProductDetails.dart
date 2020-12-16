import 'dart:ui';

import 'package:Inhaltsstoff_Warnapp/backend/Product.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Ingredient.dart';
import 'package:Inhaltsstoff_Warnapp/backend/PreferenceManager.dart';
import 'package:Inhaltsstoff_Warnapp/backend/Enums/ScanResult.dart';
import 'package:Inhaltsstoff_Warnapp/customWidgets/ResultCircle.dart';
import 'package:flutter/material.dart';

class ScanningProductDetails extends StatelessWidget {
  ScanningProductDetails({
    Key key,
    this.scannedProduct,
  }) : super(key: key) {
    _preferencesResults =
        PreferenceManager.getItemizedScanResults(scannedProduct);
    _otherIngredients = [];
    _moreProductDetails = {
      'Menge': scannedProduct.quantity.toString()?? 'keine Angabe',
      'Herkunft': scannedProduct.origin?? 'keine Angabe',
      'Herstellungsorte': scannedProduct.manufacturingPlaces?? 'keine Angabe',
      'Geschäfte': scannedProduct.stores?? 'keine Angabe',
      'Nutriscore': scannedProduct.nutriscore?? 'keine Angabe',
    };
  }

  final Product scannedProduct;
  Map<Ingredient, ScanResult> _preferencesResults;
  List<String> _otherIngredients;
  Map<String, String> _moreProductDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Text(
            'Weitere Informationen',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(16.0),
          color: Theme.of(context).accentColor,
        ),
        ExpansionTile(
          title: Text(
            "Präferenzen",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: _preferencesResults.entries
              .map(
                (entry) => ListTile(
                  title: Text(
                    entry.key.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ), //preference
                  trailing: ResultCircle(
                    entry.value,
                    small: true,
                  ), //result
                ),
              )
              .toList(),
        ),
        ExpansionTile(
          title: Text(
            "Andere Inhaltsstoffe",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: _otherIngredients
              .map(
                (ingredient) => ListTile(
                  title: Text(
                    ingredient,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              )
              .toList(),
        ),
        ExpansionTile(
          title: Text(
            "Weitere Produktdetails",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: _moreProductDetails.entries
              .map(
                (detail) => ListTile(
                  title: Text(
                    detail.key,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Text(
                    detail.value,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
