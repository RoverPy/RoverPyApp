import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      splashColor: Colors.purple,
      accentColor: Colors.blue,
      textTheme: Texts.textTheme(isDarkTheme, context),
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
    );
  }
}

class Texts {
  static TextTheme textTheme(bool isDarkTheme, BuildContext context) {
    return TextTheme(
      headline5: TextStyle(
          fontWeight: FontWeight.w900, fontSize: 24.0, color: Colors.white),
      subtitle2: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: isDarkTheme ? Colors.white : Colors.black),
      headline6: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
          color: isDarkTheme ? Colors.white : Colors.black),
      subtitle1: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
          color: isDarkTheme ? Colors.white : Colors.black),
      bodyText1: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
          color: isDarkTheme ? Colors.white : Colors.black),
      bodyText2: TextStyle(
          fontSize: 16.0, color: isDarkTheme ? Colors.white : Colors.black),
      caption: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
          color: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
