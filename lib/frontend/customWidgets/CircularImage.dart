import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  double diameter;
  ImageProvider image;

  CircularImage({
    Key key,
    this.diameter,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image == null
        ? CircleAvatar(
            backgroundColor: Theme.of(context).disabledColor,
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          )
        : CircleAvatar(
            backgroundColor: Theme.of(context).disabledColor,
            backgroundImage: image,
          );
  }
}
