import 'package:Inhaltsstoff_Warnapp/backend/ScanResult.dart';
import 'package:Inhaltsstoff_Warnapp/customWidgets/ResultCircle.dart';
import 'package:Inhaltsstoff_Warnapp/theme/style.dart';
import 'package:flutter/material.dart';

class ProductActionButton{
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
  const ScanningResult({ Key key }) : super(key: key);

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
          children: <Widget>[
            SizedBox(height:20.0),
            Text('Produkt', style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center),
            Text('Hersteller, Scandatum', style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center),
            SizedBox(height:20.0),
            ResultCircle(ScanResult.OKAY, small: false),
            SizedBox(height:25.0),
            _drawResultText(ScanResult.OKAY),
            SizedBox(height:20.0),
            _drawResultExplanation(ScanResult.OKAY, ['Lactose', 'Histamin']),
            SizedBox(height:10.0),
            _drawNutrimentsInfo(['Magnesium', 'B12']),
            SizedBox(height:30.0),
            _drawProductActionButtons(),
            SizedBox(height:30.0),
            SizedBox(
              height: 50,
              child: ColoredBox(
                color: Colors.blue[50],
                child: Center(
                  child: Text(
                      'Weitere Informationen',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center
                  ),
                )
              ),
            ),
            ExpansionTile(
              title: Text(
                "Präferenzen",
                style: Theme.of(context).textTheme.headline2,
              ),
              children: _drawPreferencesResults({
                'Präferenz 1': ScanResult.OKAY,
                'Präferenz 2': ScanResult.CRITICAL,
                'Präferenz 3': ScanResult.NOT_OKAY})
            ),
            ExpansionTile(
              title: Text(
                "Andere Inhaltsstoffe",
                style: Theme.of(context).textTheme.headline2,
              ),
              children: <Widget>[
                ListTile(
                  title: Text('Inhaltsstoff xy'),
                  trailing: Text('0.00g'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Weitere Produktdetails",
                style: Theme.of(context).textTheme.headline2,
              ),
              children: <Widget>[
                ListTile(
                  title: Text('Detail xy'),
                ),
              ],
            ),
          ],
        ),
      //),
    );
  }

  Widget _drawResultText(ScanResult result) {
    String _text;
    Color _color;
    switch (result){
      case ScanResult.OKAY:
        _text = 'Gute Wahl!';
        _color = Colors.green;
        break;
      case ScanResult.CRITICAL:
        _text = 'Achtung!';
        _color = Colors.yellow[800];
        break;
      case ScanResult.NOT_OKAY:
        _text = 'Schlechte Wahl!';
        _color = Colors.red;
        break;
    }
    return Text(
        _text,
        style: TextStyle(
            color: _color,
            fontSize: 25,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center
    );
  }

  Widget _drawResultExplanation(ScanResult result, List<String> unwantedIngredients){
    IconData _icon;
    String _text;
    Color _backgroundColor;
    Color _textColor;
    switch (result){
      case ScanResult.OKAY:
        _icon = Icons.done;
        _text = 'Enthält keine ungewollten Inhaltsstoffe';
        _backgroundColor = Colors.green[100];
        _textColor = Colors.green[800];
        break;
      case ScanResult.CRITICAL:
        _icon = Icons.warning;
        _text = 'Enthält ' + unwantedIngredients.reduce((value, element) => value + ', ' + element);
        _backgroundColor = Colors.yellow[100];
        _textColor = Colors.yellow[900];
        break;
      case ScanResult.NOT_OKAY:
        _icon = Icons.clear;
        _text = 'Enthält ' + unwantedIngredients.reduce((value, element) => value + ', ' + element);
        _backgroundColor = Colors.red[100];
        _textColor = Colors.red;
        break;
    }

    return ColoredBox(
      color: _backgroundColor,
      child:
      ListTile(
        leading: Icon(_icon, color: _textColor),
        title: Text(_text, style: TextStyle(fontSize: 14, color: _textColor)),
        dense: true,
      ),
    );
  }

  Widget _drawNutrimentsInfo(List<String> nutriments){
    IconData _icon;
    String _text;
    Color _backgroundColor;
    Color _textColor;

    if (nutriments.isEmpty) {
      _icon = Icons.remove;
      _text = 'Enthält keinen deiner gewünschten Nährstoffe';
      _backgroundColor = Colors.grey[200];
      _textColor = Colors.grey[600];
    }
    else {
      _icon = Icons.add;
      _text = 'Enthält ' + nutriments.reduce((value, element) => value + ', ' + element);
      _backgroundColor = Colors.green[100];
      _textColor = Colors.green[800];
    }

    return ColoredBox(
      color: _backgroundColor,
      child: ListTile(
        leading: Icon(_icon, color: _textColor),
        title: Text(_text, style: TextStyle(fontSize: 14, color: _textColor)),
        dense: true,
      ),
    );
  }

  Widget _drawProductActionButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: productActionButtons.map((ProductActionButton productActionButton) {
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
            SizedBox(height:10.0),
            Text(
                productActionButton.title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14
                )
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _drawPreferencesResults(Map<String, ScanResult> preferencesResults){
    return preferencesResults.entries.map((entry) =>
      ListTile(
          title: Text(entry.key), //preference
          trailing: ResultCircle(entry.value, small: true), //result
      )
    ).toList();
  }
}