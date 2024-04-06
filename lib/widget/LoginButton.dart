import '../utils/AnimatedCheck.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

import 'package:flutter/scheduler.dart';

enum ButtonState { Busy, Idle }

late AnimationController _checkmarkAnimationController;
late Animation<double> _checkmarkAnimation;

class LoginButton extends StatefulWidget {
  final double height;
  final double? width;
  final double minWidth;
  final Widget? loader;
  final Duration animationDuration;
  final Curve curve;
  final Curve reverseCurve;
  final Widget child;
  final Function(
      Function startLoading,
      bool Function(String studentID, String name, String password) stopLoading,
      ButtonState btnState)? onTap;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Brightness? colorBrightness;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool roundLoadingShape;
  final double borderRadius;
  final BorderSide borderSide;
  final double? disabledElevation;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Widget? success;
  LoginButton(
      {required this.height,
      this.success,
      this.width,
      this.minWidth = 0,
      this.loader,
      this.animationDuration = const Duration(milliseconds: 450),
      this.curve = Curves.easeInOutCirc,
      this.reverseCurve = Curves.easeInOutCirc,
      required this.child,
      this.onTap,
      this.color,
      this.focusColor,
      this.hoverColor,
      this.highlightColor,
      this.splashColor,
      this.colorBrightness,
      this.elevation,
      this.focusElevation,
      this.hoverElevation,
      this.highlightElevation,
      this.padding = const EdgeInsets.all(0),
      this.borderRadius = 0.0,
      this.clipBehavior = Clip.none,
      this.focusNode,
      this.materialTapTargetSize,
      this.roundLoadingShape = true,
      this.borderSide = const BorderSide(color: Colors.transparent, width: 0),
      this.disabledElevation,
      this.disabledColor,
      this.disabledTextColor})
      : assert(elevation == null || elevation >= 0.0),
        assert(focusElevation == null || focusElevation >= 0.0),
        assert(hoverElevation == null || hoverElevation >= 0.0),
        assert(highlightElevation == null || highlightElevation >= 0.0),
        assert(disabledElevation == null || disabledElevation >= 0.0),
        assert(clipBehavior != null);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with TickerProviderStateMixin {
  double? loaderWidth;

  bool? isSucceed = false;
  late Animation<double> _animation;
  late AnimationController _controller;
  ButtonState btn = ButtonState.Idle;

  final GlobalKey _buttonKey = GlobalKey();
  double _minWidth = 0;

  @override
  void initState() {
    super.initState();
    _checkmarkAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _checkmarkAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _checkmarkAnimationController,
            curve: Curves.easeInOutCirc));

    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration);

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          btn = ButtonState.Idle;
        });
      }
    });

    minWidth = widget.height;
    loaderWidth = widget.height;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateForward() {
    setState(() {
      btn = ButtonState.Busy;
    });
    _controller.forward();
  }

  bool animateReverse(String studentID, String name, String password) {
    //认证

    //如果失败
    if (!(studentID == '1' && name == 'a1' && password == 'a1')) {
      _controller.reverse();
      return false;
    }

    //如果成功
    setState(() {
      isSucceed = true;
      btn = ButtonState.Idle;
    });

    // 立即重建UI
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    _checkmarkAnimationController.forward();

    return true;
  }

  lerpWidth(a, b, t) {
    if (a == 0.0 || b == 0.0) {
      return null;
    } else {
      return a + (b - a) * t;
    }
  }

  double get minWidth => _minWidth;
  set minWidth(double w) {
    if (widget.minWidth == 0) {
      _minWidth = w;
    } else {
      _minWidth = widget.minWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return buttonBody();
      },
    );
  }

  Widget buttonBody() {
    return Container(
      height: widget.height,
      width: lerpWidth(widget.width ?? MediaQuery.of(context).size.width * 0.3,
          minWidth, _animation.value),
      child: ButtonTheme(
        height: widget.height,
        shape: RoundedRectangleBorder(
          side: widget.borderSide,
          borderRadius: BorderRadius.circular(widget.roundLoadingShape
              ? lerpDouble(
                  widget.borderRadius, widget.height / 2, _animation.value)!
              : widget.borderRadius),
        ),
        child: ElevatedButton(
          key: _buttonKey,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blueAccent;
              }
              return Colors.black;
            }),
            overlayColor: MaterialStateProperty.all(widget.focusColor),
            elevation: MaterialStateProperty.all(widget.elevation),
            padding: MaterialStateProperty.all(widget.padding),
          ),
          focusNode: widget.focusNode,
          onPressed: () {
            widget.onTap!(animateForward, animateReverse, btn);
          },
          child: isSucceed == false
              ? (btn == ButtonState.Idle ? widget.child : widget.loader)
              : widget.success ??
                  AnimatedCheck(
                    color: Color.fromARGB(255, 20, 235, 243),
                    progress: _checkmarkAnimation,
                    size: 100,
                  ),
        ),
      ),
    );
  }

  void rebuild() {
    setState(() {});
  }
}
