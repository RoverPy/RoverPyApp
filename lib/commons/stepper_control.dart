import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class StepperTouch extends StatefulWidget {
  const StepperTouch({
    Key key,
    this.size = 300.0,
    this.onEnd,
    this.onHoldDown,
    @required this.initialValue,
    @required this.positiveValue,
    @required this.negativeValue,
    this.direction = Axis.horizontal,
    this.withSpring = true,
  }) : super(key: key);

  /// the orientation of the stepper its horizontal or vertical.
  final Axis direction;

  final String initialValue;
  final String positiveValue;
  final String negativeValue;

  /// called whenever the stepper is released
  final ValueChanged<String> onEnd;

  /// called whenever the stepper is moved
  final ValueChanged<String> onHoldDown;

  /// if you want a springSimulation to happens the the user let go the stepper
  /// defaults to true
  final bool withSpring;
  final double size;
  final Color buttonsColor = Colors.blue;

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<StepperTouch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Color _color;
  String _value;
  double _startAnimationPosX;
  double _startAnimationPosY;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _color = Color.fromRGBO(0, 255, 255, 1);
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: widget.direction == Axis.horizontal
            ? widget.size
            : widget.size / 2 - 30.0,
        height: widget.direction == Axis.horizontal
            ? widget.size / 2 - 30.0
            : widget.size,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(60.0),
          color: Colors.blue.withOpacity(0.2),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: widget.direction == Axis.horizontal ? 10.0 : null,
                bottom: widget.direction == Axis.horizontal ? null : 10.0,
                child: Icon(
                    widget.direction == Axis.horizontal
                        ? Icons.arrow_left
                        : Icons.arrow_drop_down,
                    size: 40.0,
                    color: widget.buttonsColor),
              ),
              Positioned(
                right: widget.direction == Axis.horizontal ? 10.0 : null,
                top: widget.direction == Axis.horizontal ? null : 10.0,
                child: Icon(
                    widget.direction == Axis.horizontal
                        ? Icons.arrow_right
                        : Icons.arrow_drop_up,
                    size: 40.0,
                    color: widget.buttonsColor),
              ),
              GestureDetector(
                onHorizontalDragStart: _onPanStart,
                onHorizontalDragUpdate: _onPanUpdate,
                onHorizontalDragEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation,
                  child: Material(
                    shape: const CircleBorder(),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: widget.size / 3,
                      decoration: BoxDecoration(
                        color: _color,
                        shape: BoxShape.circle,
                      ),
                      curve: Curves.linear,
                    ),
                    elevation: 5.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;
    if (widget.direction == Axis.horizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
    setState(() {
      //int r = 0 + ((_controller.value * 2).abs() * 255).round();
      int g = 255 - ((_controller.value * 2).abs() * 255).round();
      _color = Color.fromRGBO(0, g, 255, 1);
    });
    if (_controller.value <= -0.10) {
      setState(() => _value = widget.positiveValue);
    } else if (_controller.value >= 0.10) {
      setState(() => _value = widget.negativeValue);
    }
    if (widget.onHoldDown != null) {
      widget.onHoldDown(_value);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
          new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      if (widget.direction == Axis.horizontal) {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
      } else {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }
    _value = widget.initialValue;
    if (widget.onEnd != null) {
      widget.onEnd(_value);
    }
    setState(() {
      _color = Color.fromRGBO(0, 255, 255, 1);
    });
  }
}
