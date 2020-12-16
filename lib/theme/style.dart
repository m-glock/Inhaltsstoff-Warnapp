import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Colors.indigo[700],
    accentColor: Colors.indigo[100],
    disabledColor: Colors.grey[400],
    backgroundColor: Colors.white,
    primaryColorLight: Colors.white, // On dark backgrounds
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w400,
        color: Colors.indigo,
      ),
      headline2: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: Colors.indigo,
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
      subtitle2: TextStyle(
        fontSize: 10.0,
        color: Colors.grey[900],
        fontWeight: FontWeight.bold,
      ),
      button: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    //elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(),),
    /*buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: Colors.indigo[700],
        secondary: Colors.indigo[100],
        error: Colors.red,
      ),
    ),*/
  );
}
