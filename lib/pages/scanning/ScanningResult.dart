import 'package:Inhaltsstoff_Warnapp/theme/style.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: /*Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: */ListView(
          children: <Widget>[
            SizedBox(height:20.0),
            Text('Produkt', style: appTheme().textTheme.headline1, textAlign: TextAlign.center),
            Text('Hersteller, Scandatum', style: appTheme().textTheme.headline2, textAlign: TextAlign.center),
            SizedBox(height:20.0),
            drawResultCircle(Colors.green, Icons.done),
            //drawResultCircle(Colors.yellow, Icons.warning),
            //drawResultCircle(Colors.red, Icons.clear),
            ExpansionTile(
              title: Text(
                "Präferenzen",
                style: appTheme().textTheme.headline2,
              ),
              children: <Widget>[
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Inhaltsstoff xy',
                      textAlign: TextAlign.left,
                      style: appTheme().textTheme.bodyText1,
                    ),
                    Icon(Icons.circle, color: Colors.green),
                  ],
                ),*/
                ListTile(
                  title: Text('Inhaltsstoff xy'),
                  trailing: Icon(Icons.circle, color: Colors.green),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Andere Inhaltsstoffe",
                style: appTheme().textTheme.headline2,
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
                style: appTheme().textTheme.headline2,
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

  Widget drawResultCircle(Color circleColor, IconData resultIcon){
    return Container(
      width: 250,
      height: 250,
      child: Icon(resultIcon, size: 150, color: Colors.white,),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}