import 'dart:async';
import 'package:flutter/material.dart';

class ShowUp extends StatefulWidget {
  final Key key;
  final Widget child;
  final int delay;

  ShowUp({@required this.child, this.delay, this.key});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}

class FadeIn extends StatefulWidget {
  final Key key;
  final Widget child;
  final int delay;

  FadeIn({@required this.child, this.delay, this.key});

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with TickerProviderStateMixin {
  AnimationController _animController;
  Animation<double> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animOffset = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animController);

  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animController.forward();
    return FadeTransition(
      child: widget.child,
      opacity: _animController,
    );
  }
}