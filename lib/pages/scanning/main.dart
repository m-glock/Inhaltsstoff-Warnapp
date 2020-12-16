import 'package:flutter/material.dart';

import './ScanningResult.dart';
import './ScanningRoot.dart';
import '../../backend/Product.dart';
import '../../backend/FoodApiAccess.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({Key key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  Product _testProduct;

  @override
  void initState() {
    super.initState();
    setTestProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return ScanningRoot();
              case '/result':
                return _testProduct == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ScanningResult(_testProduct);
              //return ScanningResult(testProduct);
            }
          },
        );
      },
    );
  }

  Future<void> setTestProduct() async {
    //var product = await FoodApiAccess.scanProduct('4009077020122');
    var product = await FoodApiAccess.scanProduct('9001400005030');
    setState(() {
      _testProduct = product;
    });
  }
}
