import 'package:flutter/material.dart';

class FavouritesRoot extends StatefulWidget {
  const FavouritesRoot({ Key key }) : super(key: key);

  @override
  _FavouritesRootState createState() => _FavouritesRootState();
}

class _FavouritesRootState extends State<FavouritesRoot> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: "FavouritesRoot",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FavouritesRoot'),
        backgroundColor: Colors.blue,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: Icon(
              Icons.settings,
              size: 26.0,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ElevatedButton(
          child: Text('Go to second screen'),
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/second');
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