import 'package:Essbar/frontend/customWidgets/ComingSoonView.dart';
import 'package:flutter/material.dart';
import '../../customWidgets/CustomAppBar.dart';

class AnalysisRootPage extends StatelessWidget {
  const AnalysisRootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Analyse'),
      backgroundColor: Colors.white,
      body: ComingSoonView(
        teaser: 'Hier kannst du bald deine Einkäufe analysieren.',
      ),
    );
  }
}
