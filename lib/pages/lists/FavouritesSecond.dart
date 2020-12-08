import '../../customWidgets/CustomAppBar.dart';
import 'package:flutter/material.dart';

class FavouritesSecond extends StatefulWidget {
  const FavouritesSecond({ Key key }) : super(key: key);

  @override
  _FavouritesSecondState createState() => _FavouritesSecondState();
}

class _FavouritesSecondState extends State<FavouritesSecond> {
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