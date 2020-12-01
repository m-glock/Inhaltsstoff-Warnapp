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
            //drawResultCircle(Colors.yellow[600], Icons.warning),
            //drawResultCircle(Colors.red, Icons.clear),
            SizedBox(height:25.0),
            getResultText('Good Choice!', Colors.green),
            //getResultText('Caution!', Colors.yellow[600]),
            //getResultText('Bad Choice!', Colors.red),
            SizedBox(height:20.0),
            ColoredBox(
              color: Colors.green[100],
              child:
              ListTile(
                leading: Icon(Icons.done, color: Colors.green[800]),
                title: Text('Enthält keine ungewollten Inhaltsstoffe', style: TextStyle(fontSize: 14, color: Colors.green[800])),
                dense: true,
              ),
            ),
            SizedBox(height:10.0),
            ColoredBox(
              color: Colors.green[100],
              child: ListTile(
                leading: Icon(Icons.add, color: Colors.green[800]),
                title: Text('Enthält Magnesium, B12', style: TextStyle(fontSize: 14, color: Colors.green[800])),
                dense: true,
              ),
            ),
            SizedBox(height:30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: appTheme().primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        //Icons.list,
                        Icons.favorite,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    SizedBox(height:10.0),
                    Text('Speichern', style: TextStyle(color: appTheme().primaryColor, fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: appTheme().primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.compare_arrows,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    SizedBox(height:10.0),
                    Text('Vergleichen', style: TextStyle(color: appTheme().primaryColor, fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: appTheme().primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    SizedBox(height:10.0),
                    Text('Kaufen', style: TextStyle(color: appTheme().primaryColor, fontSize: 14)),
                  ],
                ),
              ]
            ),
            SizedBox(height:30.0),
            SizedBox(
              height: 50,
              child: ColoredBox(
                color: Colors.blue[50],
                child: Center(
                  child: Text('Weitere Informationen', style: appTheme().textTheme.headline2, textAlign: TextAlign.center),
                )
              ),
            ),
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
      width: 200,
      height: 200,
      child: Icon(resultIcon, size: 100, color: Colors.white,),
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

  Widget getResultText(String choiceText, Color textColor){
    return Text(
        choiceText,
        style: TextStyle(
            color: textColor,
            fontSize: 25,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center
    );
  }
}