import 'package:flutter/material.dart';
import '../../customWidgets/CustomAppBar.dart';

class AnalysisRootPage extends StatefulWidget {
  const AnalysisRootPage({Key key}) : super(key: key);

  @override
  _AnalysisRootPageState createState() => _AnalysisRootPageState();
}

class _AnalysisRootPageState extends State<AnalysisRootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Analyse'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/undraw_in_progress.png',
            ),
            Text(
              'Coming soon!',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
