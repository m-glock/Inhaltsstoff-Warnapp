import 'package:flutter/material.dart';

import '../backend/Enums/ScanResult.dart';

class ResultCircle extends StatelessWidget {
  ScanResult result;
  bool small = true;

  ResultCircle(
      {
        Key key,
        this.result,
        this.small,
      }
  )  : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (small){
      return Icon(Icons.circle, color: getCircleColor());
    }
    else {
      return Container(
        width: 200,
        height: 200,
        child: Icon(getCircleIcon(), size: 100, color: Colors.white,),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getCircleColor(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 8,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
      );
    }
  }

  Color getCircleColor(){
    switch(result){
      case ScanResult.Green:
        return Colors.green;
        break;
      case ScanResult.Yellow:
        return Colors.yellow[700];
        break;
      case ScanResult.Red:
        return Colors.red;
        break;
    }
  }

  IconData getCircleIcon(){
    switch(result){
      case ScanResult.Green:
        return Icons.done;
        break;
      case ScanResult.Yellow:
        return Icons.warning;
        break;
      case ScanResult.Red:
        return Icons.clear;
        break;
    }
  }
}
