import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../backend/Enums/ScanResult.dart';
import '../../backend/PreferenceManager.dart';
import '../../backend/Product.dart';
import '../../customWidgets/CustomAppBar.dart';
import '../../customWidgets/ResultCircle.dart';
import './scanningCustomWidgets/ScanningInfoLine.dart';
import './scanningCustomWidgets/ScanningProductDetails.dart';
import './scanningCustomWidgets/ScanningProductNutrimentsInfo.dart';

class ProductActionButton {
  ProductActionButton(this.title, this.icon, this.onPressed);

  String title;
  IconData icon;
  void Function() onPressed;
}

List<ProductActionButton> productActionButtons = [
  ProductActionButton('Speichern', Icons.favorite, () {}),
  ProductActionButton('Vergleichen', Icons.compare_arrows, () {}),
  ProductActionButton('Kaufen', Icons.add_shopping_cart, () {}),
];

class ScanResultAppearance {
  ScanResultAppearance(this.icon, this.textColor, this.backgroundColor,
      this.resultText, this.explanationText);

  IconData icon;
  Color textColor;
  Color backgroundColor;
  String resultText;
  String explanationText;
}

class ScanningResult extends StatelessWidget {
  ScanningResult(this.scannedProduct, {Key key}) : super(key: key);

  final Product scannedProduct;

  get _getScanResultAppearance {
    switch (scannedProduct.scanResult) {
      case ScanResult.Green:
        return ScanResultAppearance(Icons.done, Colors.green, Colors.green[100],
            'Gute Wahl!', 'Enthält keine ungewollten Inhaltsstoffe.');
      case ScanResult.Yellow:
        return ScanResultAppearance(
            Icons.warning,
            Colors.yellow[800],
            Colors.yellow[100],
            'Achtung!',
            'Enthält ' +
                scannedProduct
                    .getDecisiveIngredientNames(true)
                    .reduce((value, element) => value + ', ' + element));
      case ScanResult.Red:
        return ScanResultAppearance(
            Icons.clear,
            Colors.red,
            Colors.red[100],
            'Schlechte Wahl!',
            'Enthält ' +
                scannedProduct
                    .getDecisiveIngredientNames(true)
                    .reduce((value, element) => value + ', ' + element));
      default:
        throw ('illegal State: result is not of type ScanResult');
    }
  }

  get _getAdditionalProductDetails {
    return {
      'Menge': scannedProduct.quantity.toString() ?? 'keine Angabe',
      'Herkunft': scannedProduct.origin ?? 'keine Angabe',
      'Herstellungsorte': scannedProduct.manufacturingPlaces ?? 'keine Angabe',
      'Geschäfte': scannedProduct.stores ?? 'keine Angabe',
      'Nutriscore': scannedProduct.nutriscore ?? 'keine Angabe',
    };
  }

  Widget _buildProductActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          productActionButtons.map((ProductActionButton productActionButton) {
        return Column(
          children: [
            RaisedButton(
              onPressed: productActionButton.onPressed,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Icon(
                productActionButton.icon,
                size: 24,
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            ),
            SizedBox(height: 10.0),
            Text(productActionButton.title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 14)),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScanResultAppearance _currentResultAppearance = _getScanResultAppearance;
    return Scaffold(
      appBar: CustomAppBar('Scan-Ergebnis'),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          Text(
            scannedProduct.name,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Text(
            new DateFormat('dd.MM.yyyy').format(scannedProduct.scanDate),
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ResultCircle(
              result: scannedProduct.scanResult,
              small: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Text(
              _currentResultAppearance.resultText,
              style: TextStyle(
                color: _currentResultAppearance.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: ScanningInfoLine(
              backgroundColor: _currentResultAppearance.backgroundColor,
              textColor: _currentResultAppearance.textColor,
              icon: _currentResultAppearance.icon,
              text: _currentResultAppearance.explanationText,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: ScanningProductNutrimentsInfo(
              nutriments: scannedProduct.getDecisiveIngredientNames(
                false,
              ),
            ),
          ),
          _buildProductActionButtons(context),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ScanningProductDetails(
              preferencesResults:
                  PreferenceManager.getItemizedScanResults(scannedProduct),
              otherIngredients: [],
              moreProductDetails: _getAdditionalProductDetails,
            ),
          )
        ],
      ),
    );
  }
}
