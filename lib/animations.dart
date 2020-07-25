import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:sign_in/auth/login.dart';
import 'package:sign_in/auth/register.dart';

class AuthDemo extends StatefulWidget {
  @override
  _AuthDemoState createState() => _AuthDemoState();
}

class _AuthDemoState extends State<AuthDemo>
    with SingleTickerProviderStateMixin {
  String _animationName = "Flow";
  Animation<Offset> classificationAnimation;
  AnimationController controller;
  bool controly = false;
  void toggleView() {
    setState(() {
      controly = !controly;
    });
  }

  @override
  void dispose() {
    assert(() {
      if (controller == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('AnimationController.dispose() called more than once.'),
        ]);
      }
      return true;
    }());
    controller.dispose();
    controller = null;
    super.dispose();
  }

  Widget showWidget() {
    controller.forward();
    return controly
        ? SlideTransition(
            position: classificationAnimation,
            child: (Container(
              alignment: Alignment.center,
              child: LoginScreen(
                toggleView: toggleView,
                controller: dispose,
              ),
            )),
          )
        : SlideTransition(
            position: classificationAnimation,
            child: (Container(
              alignment: Alignment.center,
              child: Register(toggleView: toggleView, controller: dispose),
            )),
          );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    classificationAnimation = Tween<Offset>(
      begin: Offset(6.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.5,
          0.7,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FlareActor(
            'assets/background.flr',
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            animation: _animationName,
            callback: (String val) {
              setState(() {
                _animationName = "Flow";
              });
            },
          ),
          showWidget(),
        ],
        overflow: Overflow.clip,
      ),
    );
  }
}
