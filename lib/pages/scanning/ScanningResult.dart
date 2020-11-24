import 'package:flutter/material.dart';

class ScanningResult extends StatefulWidget {
  const ScanningResult({ Key key }) : super(key: key);

  @override
  _ScanningResultState createState() => _ScanningResultState();
}

class _ScanningResultState extends State<ScanningResult> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "Scanning Result",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanning Result'),
        backgroundColor: Colors.blue,
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