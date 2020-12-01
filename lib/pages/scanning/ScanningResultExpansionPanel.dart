
import 'package:Inhaltsstoff_Warnapp/theme/style.dart';
import 'package:flutter/material.dart';

class ScanningResultExpansionPanel extends StatefulWidget {
  const ScanningResultExpansionPanel({ Key key }) : super(key: key);

  @override
  _ScanningResultExpansionPanelState createState() => _ScanningResultExpansionPanelState();
}

class ExpandableItem {
  bool isExpanded;
  final String header;
  final Widget body;
  ExpandableItem(this.isExpanded, this.header, this.body);
}

class _ScanningResultExpansionPanelState extends State<ScanningResultExpansionPanel> {

  List<ExpandableItem> items = <ExpandableItem>[
    ExpandableItem(
        false, // isExpanded ?
        'Präferenzen', // header
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Inhaltsstoff xy'),
                      Icon(Icons.circle, color: Colors.green),
                    ],
                  ),
                ]
            )
        ), // body
    ),
    ExpandableItem(
        false, // isExpanded ?
        'Andere Inhaltsstoffe', // header
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Inhaltsstoff xy'),
                    ],
                  ),
                ]
            )
        ), // body
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Ergebnis'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  items[index].isExpanded = !items[index].isExpanded;
                });
              },
              children: items.map((ExpandableItem item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return  ListTile(
                        //leading: item.isExpanded ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                        title:  Text(
                          item.header,
                          textAlign: TextAlign.left,
                          style: appTheme().textTheme.headline2,
                        ),
                    );
                  },
                  isExpanded: item.isExpanded,
                  body: item.body,
                  canTapOnHeader: true,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}