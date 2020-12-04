import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Colors.teal,
    accentColor: Colors.teal[100],
    disabledColor: Colors.teal[100],
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 36.0, color: Colors.teal),
      headline2: TextStyle(fontSize: 20.0, color: Colors.teal),
      bodyText1: TextStyle(fontSize: 14.0, color: Colors.black87),
      bodyText2: TextStyle(fontSize: 10.0, color: Colors.black87),
      button: TextStyle(fontSize: 10.0, color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ), 
  );
}