import 'package:Inhaltsstoff_Warnapp/backend/Enums/ScanResult.dart';
import 'package:flutter/material.dart';

class ResultCircle extends StatelessWidget {
  ScanResult result;
  bool small = true;
  Color _color;
  IconData _icon;

  ResultCircle(
      this.result,
      {
        this.small,
        Key key,
      }
  )  : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setColorAndIcon();
    if (small){
      return _drawSmallResultCircle();
    }
    else {
      return _drawBigResultCircle();
    }
  }

  _setColorAndIcon(){
    switch(result){
      case ScanResult.Green:
        _color = Colors.green;
        _icon = Icons.done;
        break;
      case ScanResult.Yellow:
        _color = Colors.yellow[700];
        _icon = Icons.warning;
        break;
      case ScanResult.Red:
        _color = Colors.red;
        _icon = Icons.clear;
        break;
    }
  }

  Widget _drawSmallResultCircle(){
    return Icon(Icons.circle, color: _color);
  }

  Widget _drawBigResultCircle(){
    return Container(
      width: 200,
      height: 200,
      child: Icon(_icon, size: 100, color: Colors.white,),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
