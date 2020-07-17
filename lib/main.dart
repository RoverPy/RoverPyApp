import 'package:flutter/material.dart';
import 'package:sign_in/wrapper.dart';
import './services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
        value: AuthService().userDetai, child: Wrapper());
  }
}
