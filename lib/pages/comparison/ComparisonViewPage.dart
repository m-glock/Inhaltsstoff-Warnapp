import 'package:Inhaltsstoff_Warnapp/backend/Enums/ScanResult.dart';
import 'package:Inhaltsstoff_Warnapp/backend/PreferenceManager.dart';
import 'package:Inhaltsstoff_Warnapp/customWidgets/ResultCircle.dart';
import 'package:Inhaltsstoff_Warnapp/pages/comparison/comparisonCustomWidgets/ComparisonSelectedProductCard.dart';
import 'package:flutter/material.dart';

import '../../backend/Product.dart';

class ComparisonViewPage extends StatelessWidget {
  const ComparisonViewPage({
    Key key,
    this.productOne,
    this.productTwo,
  }) : super(key: key);

  final Product productOne;
  final Product productTwo;

  @override
  Widget build(BuildContext context) {
    var resultsProductOne =
        PreferenceManager.getItemizedScanResults(productOne);
    var resultsProductTwo =
        PreferenceManager.getItemizedScanResults(productTwo);
    return ListView(
      padding: EdgeInsets.all(24.0),
      children: <Widget>[
        Stack(
          children: [
            /*Positioned.fill(
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ColoredBox(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ColoredBox(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ComparisonSelectedProductCard(
                          productNumber: 1,
                          productName: productOne.name,
                          scanDate: productOne.scanDate,
                          showInfoButton: false,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ComparisonSelectedProductCard(
                          productNumber: 2,
                          productName: productTwo.name,
                          scanDate: productTwo.scanDate,
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
                  children: PreferenceManager.getPreferencedIngredients()
                      .map((preference) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ResultCircle(
                              result: resultsProductOne[preference],
                              small: true,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: ColoredBox(
                              color: Theme.of(context).accentColor,
                              child: Center(
                                child: Text(
                                  preference.name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ResultCircle(
                              result: resultsProductTwo[preference],
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
                ),
                ExpansionTile(
                  title: Text(
                    'Weitere Produktdetails',
                    style: Theme.of(context).textTheme.headline2,
                    //textAlign: TextAlign.center,
                  ),
                  initiallyExpanded: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
