import 'package:flutter/material.dart';

import '../../customWidgets/CustomAppBar.dart';
import '../../backend/Product.dart';
import './ComparisonViewPage.dart';
import './ComparisonSelectionPage.dart';

class ComparisonRoot extends StatefulWidget {
  const ComparisonRoot({Key key, this.productOne}) : super(key: key);

  final Product productOne;

  @override
  _ComparisonRootState createState() => _ComparisonRootState();
}

class _ComparisonRootState extends State<ComparisonRoot> {
  Product _productOne;
  Product _productTwo;

  @override
  void initState() {
    super.initState();
    _productOne = widget.productOne;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Vergleich'),
        backgroundColor: Colors.white,
        body: _productOne == null || _productTwo == null
            ? ComparisonSelectionPage(
                productOne: _productOne,
                  //product for test
                  /*new Product(
                    'Produktname',
                    'https://googleflutter.com/sample_image.jpg',
                    '4009077020122',
                    DateTime.now()),*/
                onSelectedProducts: (productOne, productTwo) {
                  setState(() {
                    _productOne = productOne;
                    _productTwo = productTwo;
                  });
                },
              )
            : ComparisonViewPage(
                productOne: _productOne,
                productTwo: _productTwo,
              ));
  }
}
