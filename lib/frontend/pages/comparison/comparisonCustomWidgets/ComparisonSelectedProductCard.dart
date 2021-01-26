import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../backend/enums/ScanResult.dart';

class ComparisonSelectedProductCard extends StatelessWidget {
  const ComparisonSelectedProductCard({
    Key key,
    this.productNumber,
    this.productName,
    this.scanDate,
    this.useScanResultSpecificBackgroundColor,
    this.scanResult,
    this.showInfoButton,
    this.onInfoButtonPressed,
  }) : super(key: key);

  final int productNumber;
  final String productName;
  final DateTime scanDate;
  final bool useScanResultSpecificBackgroundColor;
  final ScanResult scanResult;
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
    return Card(
      color: useScanResultSpecificBackgroundColor
          ? _getResultSpecificBackgroundColor
          : Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
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
    );
  }

  get _getResultSpecificBackgroundColor {
    switch (scanResult) {
      case ScanResult.Green:
        return Colors.green[50];
      case ScanResult.Yellow:
        return Colors.yellow[100];
      case ScanResult.Red:
        return Colors.red[50];
    }
  }
}
