import 'package:Inhaltsstoff_Warnapp/backend/ScanResult.dart';
import 'package:Inhaltsstoff_Warnapp/customWidgets/ResultCircle.dart';
import 'package:Inhaltsstoff_Warnapp/pages/scanning/scanningCustomWidgets/ScanningProductDetails.dart';
import 'package:Inhaltsstoff_Warnapp/pages/scanning/scanningCustomWidgets/ScanningProductNutrimentsInfo.dart';
import 'package:Inhaltsstoff_Warnapp/pages/scanning/scanningCustomWidgets/ScanningResultExplanation.dart';
import 'package:Inhaltsstoff_Warnapp/pages/scanning/scanningCustomWidgets/ScanningResultText.dart';
import 'package:flutter/material.dart';

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

class ScanningResult extends StatefulWidget {
  const ScanningResult({Key key}) : super(key: key);

  @override
  _ScanningResultState createState() => _ScanningResultState();
}

class _ScanningResultState extends State<ScanningResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Ergebnis'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          Text(
            'Produkt',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Text(
            'Hersteller, Scandatum',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ResultCircle(
              ScanResult.NOT_OKAY,
              small: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: ScanningResultText(
              result: ScanResult.NOT_OKAY,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: ScanningResultExplanation(
              result: ScanResult.NOT_OKAY,
              unwantedIngredients: ['Lactose', 'Histamin'],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: ScanningProductNutrimentsInfo(
              //nutriments: ['Magnesium', 'B12'],
              nutriments: [],
            ),
          ),
          _buildProductActionButtons(),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ScanningProductDetails(
              {
                'Präferenz 1': ScanResult.OKAY,
                'Präferenz 2': ScanResult.CRITICAL
              },
              ['Inhaltsstoff x', 'Inhaltsstoff y'],
              {'Detail xy': 'x'},
            ),
          )
        ],
      ),
      //),
    );
  }

  Widget _buildProductActionButtons() {
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
}
