import 'package:flutter/material.dart';

class ScanningRoot extends StatefulWidget {
  const ScanningRoot({ Key key }) : super(key: key);

  @override
  _ScanningRootState createState() => _ScanningRootState();
}

class _ScanningRootState extends State<ScanningRoot> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "ScanningRoot",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScanningRoot'),
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