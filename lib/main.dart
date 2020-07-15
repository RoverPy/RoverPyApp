import 'package:flutter/material.dart';
import 'package:sign_in/animations.dart';

void main() => runApp(MaterialApp(
  title: 'Authentication',
  theme: ThemeData(
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'Lexend_Deca',
      ),
      bodyText2: TextStyle(
        fontFamily: 'Lexend_Deca',
      )
    )
  ),
  home: AuthDemo(),

));