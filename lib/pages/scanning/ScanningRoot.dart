import 'package:flutter/material.dart';
import '../../customWidgets/CustomAppBar.dart';

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
      appBar: CustomAppBar('Scannen'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ElevatedButton(
          child: Text('Go to scan result screen'),
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/result');
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}