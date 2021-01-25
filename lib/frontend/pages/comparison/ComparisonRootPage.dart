import 'package:flutter/material.dart';

import '../../../backend/databaseEntities/Product.dart';
import '../../customWidgets/CustomAppBar.dart';
import './ComparisonSelectionPage.dart';
import './ComparisonViewPage.dart';

class ComparisonRootPage extends StatelessWidget {
  const ComparisonRootPage({Key key, this.productOne}) : super(key: key);

  final Product productOne;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Vergleich'),
      backgroundColor: Colors.white,
      body: ComparisonSelectionPage(
        productOne: productOne,
        onSelectedProducts: (productOne, productTwo) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ComparisonViewPage(
                productOne: productOne,
                productTwo: productTwo,
              ),
            ),
          );
        },
      ),
    );
  }
}
