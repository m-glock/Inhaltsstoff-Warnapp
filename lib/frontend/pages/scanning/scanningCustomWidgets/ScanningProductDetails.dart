import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../backend/PreferenceManager.dart';
import '../../../../backend/Enums/PreferenceType.dart';
import '../../../../backend/Ingredient.dart';
import '../../../../backend/Enums/ScanResult.dart';
import '../../../customWidgets/ResultCircle.dart';

class ScanningProductDetails extends StatefulWidget {
  ScanningProductDetails({
    Key key,
    this.preferencesResults,
    this.preferredIngredientsInProduct,
    this.otherIngredients,
    this.moreProductDetails,
  }) : super(key: key);

  final Map<Ingredient, ScanResult> preferencesResults;

  //TODO: get preferences of type Preferred
  final List<String> preferredIngredientsInProduct;
  final List<String> otherIngredients;
  final Map<String, String> moreProductDetails;

  @override
  _ScanningProductDetailsState createState() => _ScanningProductDetailsState();
}

class _ScanningProductDetailsState extends State<ScanningProductDetails> {
  List<String> _preferredIngredientsNames;

  @override
  void initState() {
    super.initState();
    _getPreferredIngredients();
  }

  void _getPreferredIngredients() async {
    var preferredIngredients =
        await PreferenceManager.getPreferencedIngredients(
            [PreferenceType.Preferred]);
    setState(() {
      _preferredIngredientsNames =
          preferredIngredients.map((ingredient) => ingredient.name).toList();
    });
  }

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
          children: _preferredIngredientsNames == null
              ? [CircularProgressIndicator()]
              : [
                  ...widget.preferencesResults.entries
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
                      .cast<Widget>()
                      .toList(),
                  ..._preferredIngredientsNames
                      .map(
                        (preferredIngredientName) => ListTile(
                          title: Text(
                            preferredIngredientName,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: Icon(widget.preferredIngredientsInProduct
                                  .contains(preferredIngredientName)
                              ? Icons.done
                              : Icons.clear),
                        ),
                      )
                      .toList()
                ],
        ),
        ExpansionTile(
          title: Text(
            "Andere Inhaltsstoffe",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: widget.otherIngredients
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
        if (widget.moreProductDetails.entries.isNotEmpty)
          ExpansionTile(
            title: Text(
              "Weitere Produktdetails",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            children: widget.moreProductDetails.entries
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
