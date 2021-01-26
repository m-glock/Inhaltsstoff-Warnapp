import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../backend/databaseEntities/FavouritesList.dart';
import '../../../backend/databaseEntities/Ingredient.dart';
import '../../../backend/databaseEntities/Product.dart';
import '../../../backend/enums/ScanResult.dart';
import '../../../backend/ListManager.dart';
import '../../../backend/PreferenceManager.dart';
import '../../customWidgets/CustomAppBar.dart';
import '../../customWidgets/EditableTitle.dart';
import '../../customWidgets/LabelledIconButton.dart';
import '../../customWidgets/ResultCircle.dart';
import '../comparison/ComparisonRootPage.dart';
import './scanningCustomWidgets/ScanningInfoLine.dart';
import './scanningCustomWidgets/ScanningProductDetails.dart';
import './scanningCustomWidgets/ScanningProductNutrimentsInfo.dart';

class ProductActionButton {
  ProductActionButton(this.title, this.icon, this.onPressed);

  String title;
  IconData icon;
  Function onPressed;
}

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
  ScanResult _scanResult;
  ScanResultAppearance _currentResultAppearance;
  List<ProductActionButton> _productActionButtons;
  Map<Ingredient, ScanResult> _itemizedScanResults;
  List<String> _containedWantedIngredientNames;
  List<String> _otherIngredientNames;

  @override
  void initState() {
    super.initState();

    _getScanResultAndAppearance();
    _getProductActionButtons(context);
    _subscribeToFavouritesListUpdate(context);
    _getContainedWantedIngredientNames();
    _getItemizedScanResults(widget.scannedProduct);
    _getOtherIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Scan-Ergebnis'),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _scanResult == null ||
              _currentResultAppearance == null ||
              _containedWantedIngredientNames == null ||
              _productActionButtons == null ||
              _itemizedScanResults == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.only(bottom: 20.0),
              children: <Widget>[
                widget.scannedProduct.barcode == null
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: ScanningInfoLine(
                          backgroundColor: Colors.red,
                          textColor: Colors.red[100],
                          icon: Icons.warning_amber_sharp,
                          text:
                              'Es konnten nicht alle Inhaltsstoffe mit den Präferenzen abgeglichen werden.',
                        ))
                    : Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                widget.scannedProduct.name.isEmpty
                    ? EditableTitle(
                        originalTitle: 'Unbenanntes Produkt',
                        onTitleChanged: (String value) {
                          widget.scannedProduct.setName(value);
                        },
                      )
                    : Text(
                        widget.scannedProduct.name,
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                Text(
                  new DateFormat('dd.MM.yyyy')
                      .format(widget.scannedProduct.scanDate),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: ResultCircle(
                    result: _scanResult,
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
                    nutriments: _containedWantedIngredientNames,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _productActionButtons
                      .map((ProductActionButton productActionButton) {
                    return LabelledIconButton(
                      label: productActionButton.title,
                      icon: productActionButton.icon,
                      isPrimary: true,
                      onPressed: productActionButton.onPressed,
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: _itemizedScanResults != null &&
                          _otherIngredientNames != null
                      ? ScanningProductDetails(
                          preferencesResults: _itemizedScanResults,
                          preferredIngredientsInProduct:
                              _containedWantedIngredientNames,
                          otherIngredients: _otherIngredientNames,
                          moreProductDetails: _getAdditionalProductDetails,
                        )
                      : CircularProgressIndicator(),
                )
              ],
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _unsubscribeToFavouritesListUpdate(context);
  }

  _getScanResultAndAppearance() async {
    ScanResult result = await widget.scannedProduct.getScanResult();
    ScanResultAppearance appearance = await _getScanResultAppearance(result);
    setState(() {
      _scanResult = result;
      _currentResultAppearance = appearance;
    });
  }

  Future<ScanResultAppearance> _getScanResultAppearance(
      ScanResult scanResult) async {
    List<String> unwantedIngredientNames =
        await _getContainedUnwantedIngredientNames();

    switch (scanResult) {
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
                unwantedIngredientNames
                    .reduce((value, element) => value + ', ' + element));
      case ScanResult.Red:
        return ScanResultAppearance(
            Icons.clear,
            Colors.red,
            Colors.red[100],
            'Schlechte Wahl!',
            'Enthält ' +
                unwantedIngredientNames
                    .reduce((value, element) => value + ', ' + element));
      default:
        throw ('illegal State: result is not of type ScanResult');
    }
  }

  Future<List<String>> _getContainedUnwantedIngredientNames() async {
    return await widget.scannedProduct
        .getDecisiveIngredientNames(getUnwantedIngredients: true);
  }

  _getContainedWantedIngredientNames() async {
    List<String> names = await widget.scannedProduct
        .getDecisiveIngredientNames(getUnwantedIngredients: false);
    setState(() {
      _containedWantedIngredientNames = names;
    });
  }

  void _getProductActionButtons(BuildContext context) async {
    FavouritesList favourites = await ListManager.instance.favouritesList;
    ProductActionButton favButton =
        favourites.getProducts().contains(widget.scannedProduct)
            ? new ProductActionButton('Entfernen', Icons.favorite, () {
                removeFavourite(context);
              })
            : new ProductActionButton('Speichern', Icons.favorite_border, () {
                addFavourite(context);
              });

    ProductActionButton compButton =
        ProductActionButton('Vergleichen', Icons.compare_arrows, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ComparisonRootPage(productOne: widget.scannedProduct),
        ),
      );
    });

    if (mounted) {
      setState(() {
        _productActionButtons = {
          favButton,
          compButton,
          ProductActionButton('Kaufen', Icons.add_shopping_cart, null),
        }.toList();
      });
    }
  }

  void addFavourite(BuildContext context) {
    ListManager.instance.favouritesList
        .then((value) => value.addProduct(widget.scannedProduct));
    _getProductActionButtons(context);
  }

  void removeFavourite(BuildContext context) {
    ListManager.instance.favouritesList
        .then((value) => value.removeProduct(widget.scannedProduct));
    _getProductActionButtons(context);
  }

  void _subscribeToFavouritesListUpdate(BuildContext context) async {
    FavouritesList favouritesList = await ListManager.instance.favouritesList;
    favouritesList.onUpdate.subscribe((args) {
      _getProductActionButtons(context);
    });
  }

  void _unsubscribeToFavouritesListUpdate(BuildContext context) async {
    FavouritesList favouritesList = await ListManager.instance.favouritesList;
    favouritesList.onUpdate.unsubscribe((args) {
      _getProductActionButtons(context);
    });
  }

  void _getItemizedScanResults(Product scannedProduct) async {
    Map<Ingredient, ScanResult> itemizedScanResults =
        await PreferenceManager.getItemizedScanResults(scannedProduct);
    setState(() {
      _itemizedScanResults = itemizedScanResults;
    });
  }

  _getOtherIngredients() async {
    List<String> names =
        await widget.scannedProduct.getNotPreferredIngredientNames();
    setState(() {
      _otherIngredientNames = names;
    });
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
}
