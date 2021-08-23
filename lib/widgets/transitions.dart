import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ScaledTransition extends StatelessWidget {
  final Widget child;
  final bool reverse;
  ScaledTransition({required this.reverse, required this.child});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      child: child,
      duration: Duration(milliseconds: 500),
      reverse: reverse,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
            child: child,
            fillColor: Colors.transparent,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled);
      },
    );
  }
}

class FadingTransition extends StatelessWidget {
  final Widget child;
  final bool reverse;
  FadingTransition({required this.reverse, required this.child});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      child: child,
      duration: Duration(milliseconds: 500),
      reverse: reverse,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          child: child,
          fillColor: Colors.transparent,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
        );
      },
    );
  }
}
