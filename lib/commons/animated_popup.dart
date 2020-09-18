import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiver/async.dart';
import 'package:sign_in/utils/data.dart';

class AnimatedPopUp extends StatefulWidget {
  final List<dynamic> images;

  AnimatedPopUp({this.images});
  @override
  _AnimatedPopUpState createState() => _AnimatedPopUpState();
}

class _AnimatedPopUpState extends State<AnimatedPopUp> {
  int elapsed = 0;

  void _incrementCounter() {

    final cd = CountdownTimer(Duration(seconds: widget.images.length-1), Duration(milliseconds: 500));
    cd.listen((data) {
      setState(() {
        elapsed = cd.elapsed.inSeconds;
        print(elapsed);
      });
    }, onDone: () {
      cd.cancel();
      Navigator.pop(context);
    });

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {_incrementCounter();});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      child: Image(
          image: NetworkImage(widget.images[elapsed]),
          key: ValueKey(elapsed)),
      duration: Duration(seconds: 1),
    );
  }
}
