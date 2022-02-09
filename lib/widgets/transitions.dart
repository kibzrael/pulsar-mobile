import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ScaledTransition extends StatelessWidget {
  final Widget child;
  final bool reverse;
  final Color fill;
  const ScaledTransition(
      {Key? key, required this.reverse,
      required this.child,
      this.fill = Colors.transparent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      child: child,
      duration: const Duration(milliseconds: 500),
      reverse: reverse,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
            child: child,
            fillColor: fill,
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
   const FadingTransition({Key? key, required this.reverse, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      child: child,
      duration: const Duration(milliseconds: 500),
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
