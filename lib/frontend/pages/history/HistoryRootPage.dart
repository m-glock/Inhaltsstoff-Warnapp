import '../../customWidgets/CustomAppBar.dart';
import 'package:flutter/material.dart';

class HistoryRootPage extends StatefulWidget {
  const HistoryRootPage({ Key key }) : super(key: key);

  @override
  _HistoryRootPageState createState() => _HistoryRootPageState();
}

class _HistoryRootPageState extends State<HistoryRootPage> {
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
      appBar: CustomAppBar('Verlauf'),
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