import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
//import 'package:sign_in/auth/login.dart';
import 'package:flutter_login/flutter_login.dart';


class AuthDemo extends StatefulWidget {
  @override
  _AuthDemoState createState() => _AuthDemoState();
}

class _AuthDemoState extends State<AuthDemo> {

  String _animationName = "Flow";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 135.0, 0, 0),
            child: FlutterLogin(
              title: '',
              onLogin: (_) => Future(null),
              onSignup: (_) => Future(null),
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => null,
                ));
              },
              onRecoverPassword: (_) => Future(null),
              theme: LoginTheme(
                  cardTheme: CardTheme(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.only(top: 15),
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0)),
                  ),
              ),
            ),
          ),
          FlareActor(
            'assets/background.flr',
            alignment: Alignment.topCenter,
            fit: BoxFit.contain,
            animation: _animationName,
            callback: (String val){
              setState(() {
                _animationName = "Flow";
              });
            },
          )
        ],
        overflow: Overflow.clip,
      ),
    );
  }
}
