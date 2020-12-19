import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../backend/Ingredient.dart';
import '../../../../backend/Enums/ScanResult.dart';
import '../../../customWidgets/ResultCircle.dart';

class ScanningProductDetails extends StatelessWidget {
  ScanningProductDetails({
    Key key,
    this.preferencesResults,
    this.otherIngredients,
    this.moreProductDetails,
  }) : super(key: key);

  final Map<Ingredient, ScanResult> preferencesResults;
  final List<String> otherIngredients;
  final Map<String, String> moreProductDetails;

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
          children: preferencesResults.entries
              .map(
                (entry) => ListTile(
                  title: Text(
                    entry.key.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ), //preference
                  trailing: ResultCircle(
                    result: entry.value,
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
          children: otherIngredients
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
          children: moreProductDetails.entries
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
