import 'package:flutter/material.dart';
import 'package:sign_in/animations.dart';
//import 'package:provider/provider.dart';
//import 'package:sign_in/services/AuthService.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
