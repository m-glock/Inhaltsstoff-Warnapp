import 'package:flutter/material.dart';

import '../../../backend/databaseEntities/Ingredient.dart';
import '../../../backend/databaseEntities/Product.dart';
import '../../../backend/enums/PreferenceType.dart';
import '../../../backend/enums/ScanResult.dart';
import '../../../backend/PreferenceManager.dart';
import '../../customWidgets/CustomAppBar.dart';
import '../../customWidgets/ResultCircle.dart';
import './comparisonCustomWidgets/ComparisonSelectedProductCard.dart';

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
  ScanResult _scanResultProductOne;
  ScanResult _scanResultProductTwo;

  List<Ingredient> _notWantedPreferences;
  Map<Ingredient, ScanResult> _itemizedResultsProductOne;
  Map<Ingredient, ScanResult> _itemizedResultsProductTwo;

  List<String> _preferredIngredientsNames;
  List<String> _preferredIngredientsInProductOne;
  List<String> _preferredIngredientsInProductTwo;

  List<String> _notPreferencedIngredientsSum;
  List<String> _notPreferencedIngredientsProductOne;
  List<String> _notPreferencedIngredientsProductTwo;

  Map<String, String> _additionalDetailsProductOne;
  Map<String, String> _additionalDetailsProductTwo;

  @override
  void initState() {
    super.initState();
    _getScanResults();

    _getNotWantedPreferences();
    _getItemizedResults();

    _getPreferredIngredients();
    _getPreferredIngredientsInProducts();

    _getNotPreferredIngredients();

    _additionalDetailsProductOne =
        _getAdditionalProductDetails(widget.productOne);
    _additionalDetailsProductTwo =
        _getAdditionalProductDetails(widget.productTwo);
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
                _scanResultProductOne == null
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: ComparisonSelectedProductCard(
                          productNumber: 1,
                          productName: widget.productOne.name,
                          scanDate: widget.productOne.scanDate,
                          useScanResultSpecificBackgroundColor: true,
                          scanResult: _scanResultProductOne,
                          showInfoButton: false,
                        ),
                      ),
                _scanResultProductTwo == null
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: ComparisonSelectedProductCard(
                          productNumber: 2,
                          productName: widget.productTwo.name,
                          scanDate: widget.productTwo.scanDate,
                          useScanResultSpecificBackgroundColor: true,
                          scanResult: _scanResultProductTwo,
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
            ),
            initiallyExpanded: true,
            children: _notWantedPreferences == null ||
                    _itemizedResultsProductOne == null ||
                    _itemizedResultsProductTwo == null ||
                    _preferredIngredientsNames == null ||
                    _preferredIngredientsInProductOne == null ||
                    _preferredIngredientsInProductTwo == null
                ? [
                    CircularProgressIndicator(),
                  ]
                : [
                    ..._notWantedPreferences.map((preference) {
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
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
                    ..._preferredIngredientsNames
                        .map((preferredIngredientName) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Icon(
                                _preferredIngredientsInProductOne
                                        .contains(preferredIngredientName)
                                    ? Icons.done
                                    : Icons.clear,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  preferredIngredientName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Icon(
                                _preferredIngredientsInProductTwo
                                        .contains(preferredIngredientName)
                                    ? Icons.done
                                    : Icons.clear,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
          ),
          ExpansionTile(
            title: Text(
              'Andere Inhaltsstoffe',
              style: Theme.of(context).textTheme.headline2,
              //textAlign: TextAlign.center,
            ),
            initiallyExpanded: true,
            children: _notPreferencedIngredientsSum == null ||
                    _notPreferencedIngredientsProductOne == null ||
                    _notPreferencedIngredientsProductTwo == null
                ? [
                    CircularProgressIndicator(),
                  ]
                : _notPreferencedIngredientsSum.map((ingredient) {
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

  void _getScanResults() async {
    ScanResult resultProductOne = await widget.productOne.getScanResult();
    ScanResult resultProductTwo = await widget.productTwo.getScanResult();
    setState(() {
      _scanResultProductOne = resultProductOne;
      _scanResultProductTwo = resultProductTwo;
    });
  }

  void _getNotWantedPreferences() async {
    var notWantedPreferences =
        await PreferenceManager.getPreferencedIngredients([
      PreferenceType.NotPreferred,
      PreferenceType.NotWanted,
    ]);
    setState(() {
      _notWantedPreferences = notWantedPreferences;
    });
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

  void _getPreferredIngredients() async {
    var preferredIngredients =
        await PreferenceManager.getPreferencedIngredients(
            [PreferenceType.Preferred]);
    setState(() {
      _preferredIngredientsNames =
          preferredIngredients.map((ingredient) => ingredient.name).toList();
    });
  }

  void _getPreferredIngredientsInProducts() async {
    List<Ingredient> preferredIngredientsInProductOne =
        await PreferenceManager.getPreferredIngredientsIn(widget.productOne);
    List<Ingredient> preferredIngredientsInProductTwo =
        await PreferenceManager.getPreferredIngredientsIn(widget.productTwo);
    setState(() {
      _preferredIngredientsInProductOne = preferredIngredientsInProductOne
          .map((ingredient) => ingredient.name)
          .toList();
      _preferredIngredientsInProductTwo = preferredIngredientsInProductTwo
          .map((ingredient) => ingredient.name)
          .toList();
    });
  }

  void _getNotPreferredIngredients() async {
    List<String> notPreferencedIngredientsProductOne =
        await widget.productOne.getNotPreferredIngredientNames();
    List<String> notPreferencedIngredientsProductTwo =
        await widget.productTwo.getNotPreferredIngredientNames();

    var notPreferencedIngredientsSet = new Set<String>();
    notPreferencedIngredientsSet.addAll(notPreferencedIngredientsProductOne);
    notPreferencedIngredientsSet.addAll(notPreferencedIngredientsProductTwo);
    List<String> notPreferencedIngredientsSum =
        notPreferencedIngredientsSet.toList();

    setState(() {
      _notPreferencedIngredientsProductOne =
          notPreferencedIngredientsProductOne;
      _notPreferencedIngredientsProductTwo =
          notPreferencedIngredientsProductTwo;
      _notPreferencedIngredientsSum = notPreferencedIngredientsSum;
    });
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
