import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComparisonSelectedProductCard extends StatelessWidget {
  const ComparisonSelectedProductCard({
    Key key,
    this.productNumber,
    this.productName,
    this.scanDate,
    this.showInfoButton,
    this.onInfoButtonPressed,
  }) : super(key: key);

  final int productNumber;
  final String productName;
  final DateTime scanDate;
  final bool showInfoButton;
  final void Function() onInfoButtonPressed;

  @override
  Widget build(BuildContext context) {
    return showInfoButton
        ? Stack(
            overflow: Overflow.visible,
            children: [
              _buildProductCard(context),
              Positioned(
                top: -16.0,
                left: -16.0,
                child: IconButton(
                  icon: Icon(Icons.info),
                  iconSize: 32.0,
                  color: Theme.of(context).primaryColor,
                  onPressed: onInfoButtonPressed,
                ),
              ),
            ],
          )
        : _buildProductCard(context);
  }

  Widget _buildProductCard(BuildContext context) {
    return Container(
      child: Card(
        color: Theme.of(context).accentColor,
        shape: Border.all(
          width: 1.5,
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'Produkt $productNumber: $productName',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Text(
                'gescannt am ' + new DateFormat('dd.MM.yyyy').format(scanDate),
                //.format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.grey[50],
            //Theme.of(context).disabledColor,
            blurRadius: 0.1,
            offset: new Offset(0.0, 1.0),
          ),
        ],
      ),
    );
  }
}
