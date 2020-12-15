import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Colors.indigo[700],
    accentColor: Colors.indigo[50],
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 36.0,
        color: Colors.indigo[700],
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: 20.0,
        color: Colors.indigo[700],
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        fontSize: 14.0,
        color: Colors.black87,
      ),
      bodyText2: TextStyle(
        fontSize: 10.0,
        color: Colors.black87,
      ),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
