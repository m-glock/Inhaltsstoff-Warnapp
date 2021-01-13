import 'package:flutter/material.dart';
import '../../customWidgets/CustomAppBar.dart';

class ComparisonRootPage extends StatefulWidget {
  const ComparisonRootPage({ Key key }) : super(key: key);

  @override
  _ComparisonRootPageState createState() => _ComparisonRootPageState();
}

class _ComparisonRootPageState extends State<ComparisonRootPage> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "Comparison",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Vergleich'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(controller: _textController),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}