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

class _AnimatedPopUpState extends State<AnimatedPopUp> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  int elapsed = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = Tween<int>(end: widget.images.length, begin: 0).animate(elapsed);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {increment();});
  }

  void increment() async {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20.0,
      height: MediaQuery.of(context).size.width - 20.0,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(widget.images[elapsed].toString()))
      ),
    );
  }
}
