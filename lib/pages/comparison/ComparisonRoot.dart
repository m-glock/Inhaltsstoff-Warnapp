import 'package:flutter/material.dart';

class ComparisonRoot extends StatefulWidget {
  const ComparisonRoot({ Key key }) : super(key: key);

  @override
  _ComparisonRootState createState() => _ComparisonRootState();
}

class _ComparisonRootState extends State<ComparisonRoot> {
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
      appBar: AppBar(
        title: Text('Comparison'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
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