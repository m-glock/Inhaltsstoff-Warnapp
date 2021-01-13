import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../backend/Enums/ScanResult.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Product.dart';
import '../../../backend/Ingredient.dart';
import '../../customWidgets/CustomAppBar.dart';
import '../../customWidgets/ResultCircle.dart';
import '../../customWidgets/EditableTitle.dart';
import '../../customWidgets/LabelledIconButton.dart';
import './scanningCustomWidgets/ScanningInfoLine.dart';
import './scanningCustomWidgets/ScanningProductNutrimentsInfo.dart';
import './scanningCustomWidgets/ScanningProductDetails.dart';

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

class ScanningResultPage extends StatefulWidget {
  const ScanningResultPage(this.scannedProduct, {Key key}) : super(key: key);
  final Product scannedProduct;

  @override
  _ScanningResultPageState createState() => _ScanningResultPageState();
}

class _ScanningResultPageState extends State<ScanningResultPage> {
  Map<Ingredient, ScanResult> _itemizedScanResults;

  @override
  void initState() {
    super.initState();
    getItemizedScanResults(widget.scannedProduct);
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
          widget.scannedProduct.name == null
              ? EditableTitle(
                  originalTitle: 'Unbenanntes Produkt',
                  onTitleChanged: (String value) {
                    widget.scannedProduct.name = value;
                  },
                )
              : Text(
                  widget.scannedProduct.name,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
          Text(
            new DateFormat('dd.MM.yyyy').format(widget.scannedProduct.scanDate),
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ResultCircle(
              result: widget.scannedProduct.scanResult,
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
              nutriments: widget.scannedProduct.getDecisiveIngredientNames(
                getUnwantedIngredients: false,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: productActionButtons
                .map((ProductActionButton productActionButton) {
              return LabelledIconButton(
                label: productActionButton.title,
                icon: productActionButton.icon,
                isPrimary: true,
                onPressed: () {},
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: _itemizedScanResults != null
                ? ScanningProductDetails(
                    preferencesResults: _itemizedScanResults,
                    otherIngredients:
                        widget.scannedProduct.getNotPreferredIngredientNames(),
                    moreProductDetails: _getAdditionalProductDetails,
                  )
                : CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  get _getScanResultAppearance {
    switch (widget.scannedProduct.scanResult) {
      case ScanResult.Green:
        return ScanResultAppearance(
          Icons.done,
          Colors.green[800],
          Colors.green[100],
          'Gute Wahl!',
          'Enthält keine ungewollten Inhaltsstoffe.',
        );
      case ScanResult.Yellow:
        return ScanResultAppearance(
            Icons.warning,
            Colors.yellow[800],
            Colors.yellow[100],
            'Achtung!',
            'Enthält ' +
                widget.scannedProduct
                    .getDecisiveIngredientNames(
                      getUnwantedIngredients: true,
                    )
                    .reduce((value, element) => value + ', ' + element));
      case ScanResult.Red:
        return ScanResultAppearance(
            Icons.clear,
            Colors.red,
            Colors.red[100],
            'Schlechte Wahl!',
            'Enthält ' +
                widget.scannedProduct
                    .getDecisiveIngredientNames(
                      getUnwantedIngredients: true,
                    )
                    .reduce((value, element) => value + ', ' + element));
      default:
        throw ('illegal State: result is not of type ScanResult');
    }
  }

  get _getAdditionalProductDetails {
    if (widget.scannedProduct.name == null) {
      return {};
    } else {
      return {
        'Menge': widget.scannedProduct.quantity.toString() ?? 'keine Angabe',
        'Herkunft': widget.scannedProduct.origin ?? 'keine Angabe',
        'Herstellungsorte':
            widget.scannedProduct.manufacturingPlaces ?? 'keine Angabe',
        'Geschäfte': widget.scannedProduct.stores ?? 'keine Angabe',
        'Nutriscore': widget.scannedProduct.nutriscore ?? 'keine Angabe',
      };
    }
  }

  getItemizedScanResults(Product scannedProduct) async {
    Map<Ingredient, ScanResult> itemizedScanResults =
        await PreferenceManager.getItemizedScanResults(scannedProduct);
    setState(() {
      _itemizedScanResults = itemizedScanResults;
    });
  }
}
