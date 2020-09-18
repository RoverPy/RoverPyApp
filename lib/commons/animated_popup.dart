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

  Widget animation(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: Tween<int>(begin: 0, end: widget.images.length-1),
      duration: Duration(milliseconds: 500*widget.images.length),
      builder: (context, index, child) {
        return Image(image: NetworkImage(widget.images[index]),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20.0,
      height: MediaQuery.of(context).size.width - 20.0,
      child: animation(context),
    );
  }
}
