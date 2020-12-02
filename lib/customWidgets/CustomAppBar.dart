import 'package:flutter/material.dart';
import '../pages/settings/SettingsRoot.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  CustomAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: Icon(Icons.settings, size: 26.0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SettingsRoot()));
          },
        ),
      ],
    );
  }
}
