import '../../customWidgets/CustomAppBar.dart';
import 'package:flutter/material.dart';

class FavouritesSecondPage extends StatefulWidget {
  const FavouritesSecondPage({ Key key }) : super(key: key);

  @override
  _FavouritesSecondPageState createState() => _FavouritesSecondPageState();
}

class _FavouritesSecondPageState extends State<FavouritesSecondPage> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "FavouritesSecond",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Favoriten Second'),
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