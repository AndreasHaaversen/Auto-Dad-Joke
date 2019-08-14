import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Tween<double>(
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
