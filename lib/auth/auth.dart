import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/auth/login_page.dart';
import 'package:pulsar/auth/signup_page.dart';

class AuthScreen extends StatefulWidget {
  final int initialPage;
  AuthScreen({this.initialPage = 0});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialPage;
  }

  onChange(int page) {
    setState(() {
      index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
        child: index == 0
            ? LoginPage(onChange: onChange)
            : SignupPage(onChange: onChange),
        duration: Duration(milliseconds: 500),
        reverse: index == 0,
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal);
        });
  }
}
