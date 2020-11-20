import 'package:flutter/material.dart';

class HistoryRoot extends StatefulWidget {
  const HistoryRoot({ Key key }) : super(key: key);

  @override
  _HistoryRootState createState() => _HistoryRootState();
}

class _HistoryRootState extends State<HistoryRoot> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "History",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
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