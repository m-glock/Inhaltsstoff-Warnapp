import 'package:flutter/material.dart';
import '../../customWidgets/CustomAppBar.dart';

class AnalysisRoot extends StatefulWidget {
  const AnalysisRoot({ Key key }) : super(key: key);

  @override
  _AnalysisRootState createState() => _AnalysisRootState();
}

class _AnalysisRootState extends State<AnalysisRoot> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "Analysis",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Analyse'),
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