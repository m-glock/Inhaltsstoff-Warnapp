import '../../../backend/Product.dart';
import '../../../backend/Enums/ScanResult.dart';
import '../../../backend/Ingredient.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../frontend/customWidgets/CustomAppBar.dart';
import '../../../frontend/customWidgets/ResultCircle.dart';
import './comparisonCustomWidgets/ComparisonSelectedProductCard.dart';

import 'package:flutter/material.dart';

class ComparisonViewPage extends StatefulWidget {
  const ComparisonViewPage({
    Key key,
    this.productOne,
    this.productTwo,
  }) : super(key: key);

  final Product productOne;
  final Product productTwo;

  @override
  _ComparisonViewPageState createState() => _ComparisonViewPageState();
}

class _ComparisonViewPageState extends State<ComparisonViewPage> {
  Map<Ingredient, ScanResult> _itemizedResultsProductOne;
  Map<Ingredient, ScanResult> _itemizedResultsProductTwo;

  List<Ingredient> _preferences;

  List<String> _notPreferencedIngredientsSum;
  List<String> _notPreferencedIngredientsProductOne;
  List<String> _notPreferencedIngredientsProductTwo;

  Map<String, String> _additionalDetailsProductOne;
  Map<String, String> _additionalDetailsProductTwo;

  @override
  void initState() {
    super.initState();
    _getItemizedResults();

    _notPreferencedIngredientsProductOne =
        widget.productOne.getNotPreferredIngredientNames();
    _notPreferencedIngredientsProductTwo =
        widget.productTwo.getNotPreferredIngredientNames();

    var notPreferencedIngredientsSet = new Set<String>();
    notPreferencedIngredientsSet.addAll(_notPreferencedIngredientsProductOne);
    notPreferencedIngredientsSet.addAll(_notPreferencedIngredientsProductTwo);
    _notPreferencedIngredientsSum = notPreferencedIngredientsSet.toList();

    _additionalDetailsProductOne =
        _getAdditionalProductDetails(widget.productOne);
    _additionalDetailsProductTwo =
        _getAdditionalProductDetails(widget.productTwo);
  }

  void _getItemizedResults() async {
    var resultsProductOne =
        await PreferenceManager.getItemizedScanResults(widget.productOne);
    var resultsProductTwo =
        await PreferenceManager.getItemizedScanResults(widget.productTwo);

    setState(() {
      _itemizedResultsProductOne = resultsProductOne;
      _itemizedResultsProductTwo = resultsProductTwo;
      //_preferences = preferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Vergleich'),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(24.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ComparisonSelectedProductCard(
                    productNumber: 1,
                    productName: widget.productOne.name,
                    scanDate: widget.productOne.scanDate,
                    useScanResultSpecificBackgroundColor: true,
                    scanResult: widget.productOne.scanResult,
                    showInfoButton: false,
                  ),
                ),
                Expanded(
                  child: ComparisonSelectedProductCard(
                    productNumber: 2,
                    productName: widget.productTwo.name,
                    scanDate: widget.productTwo.scanDate,
                    useScanResultSpecificBackgroundColor: true,
                    scanResult: widget.productTwo.scanResult,
                    showInfoButton: false,
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text(
              'Deine Präferenzen',
              style: Theme.of(context).textTheme.headline2,
              //textAlign: TextAlign.center,
            ),
            initiallyExpanded: true,
            children: _preferences == null ||
                    _itemizedResultsProductOne == null ||
                    _itemizedResultsProductTwo == null
                ? [
                    CircularProgressIndicator(),
                  ]
                : _preferences.map((preference) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ResultCircle(
                              result: _itemizedResultsProductOne[preference],
                              small: true,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                preference.name,
                                style:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ResultCircle(
                              result: _itemizedResultsProductTwo[preference],
                              small: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
          ),
          ExpansionTile(
            title: Text(
              'Andere Inhaltsstoffe',
              style: Theme.of(context).textTheme.headline2,
              //textAlign: TextAlign.center,
            ),
            initiallyExpanded: true,
            children: _notPreferencedIngredientsSum.map((ingredient) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _notPreferencedIngredientsProductOne
                              .contains(ingredient)
                          ? Icon(Icons.done)
                          : Icon(Icons.clear),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          ingredient,
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _notPreferencedIngredientsProductTwo
                              .contains(ingredient)
                          ? Icon(Icons.done)
                          : Icon(Icons.clear),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text(
              'Weitere Produktdetails',
              style: Theme.of(context).textTheme.headline2,
              //textAlign: TextAlign.center,
            ),
            initiallyExpanded: true,
            children:
                _additionalDetailsProductOne.entries.map((detailProductOne) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        detailProductOne.value,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          detailProductOne.key,
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _additionalDetailsProductTwo[detailProductOne.key],
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getAdditionalProductDetails(Product product) {
    return {
      'Menge': product.quantity ?? '-',
      'Herkunft': product.origin ?? '-',
      'Herstellungsorte': product.manufacturingPlaces ?? '-',
      'Geschäfte': product.stores ?? '-',
      'Nutriscore': product.nutriscore ?? '-',
    };
  }
}