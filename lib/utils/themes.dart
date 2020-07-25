import 'package:flutter/material.dart';

class Styles {
  static final LinearGradient background =  LinearGradient(colors: [Color(0xFF1b1e44), Color(0xFF2d3447),],begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      tileMode: TileMode.clamp);

  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      splashColor: Colors.purple,
      accentColor: Colors.blue,
      textTheme: Texts.textTheme(context),
      backgroundColor: Color(0xFF1b1e44),
    );
  }
}

class Texts {
  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 42.0,
        fontFamily: "Calibre-Semibold",
        letterSpacing: 1.0,
      ),
      headline3: TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: "Calibre-Semibold",
        fontSize: 32.0,
        color: Colors.white,
      ),
      headline5: TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: "Calibre-Semibold",
          fontSize: 24.0,
          color: Colors.white),
      headline6: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Calibre-Semibold",
          fontSize: 24.0,
          color: Colors.white),
      subtitle2: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Calibre-Semibold",
          fontSize: 20.0,
          color: Colors.white),
      subtitle1: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: "Calibre-Semibold",
          fontSize: 18.0,
          color: Colors.black),
      bodyText1: TextStyle(
          fontWeight: FontWeight.w300,
          fontFamily: "Calibre-Semibold",
          fontSize: 16.0,
          color: Colors.white),
      bodyText2: TextStyle(
          fontSize: 16.0,
          fontFamily: "Calibre-Semibold",
          color: Colors.white),
      caption: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          fontFamily: "Calibre-Semibold",
          fontSize: 14.0,
          color: Colors.white),
    );
  }
}


