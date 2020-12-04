import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.blue[100],
    disabledColor: Colors.blueAccent[100],
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 36.0, color: Colors.blue),
      headline2: TextStyle(fontSize: 20.0, color: Colors.blue),
      bodyText1: TextStyle(fontSize: 14.0, color: Colors.black87),
      bodyText2: TextStyle(fontSize: 10.0, color: Colors.black87),
      button: TextStyle(fontSize: 10.0, color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ), 
  );
}