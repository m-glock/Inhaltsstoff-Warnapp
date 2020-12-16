import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Colors.indigo[700],
    accentColor: Colors.indigo[50],
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 36.0,
        color: Colors.indigo[700],
        fontWeight: FontWeight.w400,
      ),
      headline2: TextStyle(
        fontSize: 20.0,
        color: Colors.indigo[700],
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        color: Colors.grey[900],
        fontWeight: FontWeight.bold,
      ),
      subtitle2: TextStyle(
        fontSize: 10.0,
        color: Colors.grey[900],
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey[900],
      ),
      bodyText2: TextStyle(
        fontSize: 10.0,
        color: Colors.grey[900],
      ),
    ),
  );
}
