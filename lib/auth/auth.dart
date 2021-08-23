import 'package:flutter/material.dart';
import 'package:pulsar/auth/login_page.dart';
import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/widgets/transitions.dart';

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
    return ScaledTransition(
      child: index == 0
          ? LoginPage(onChange: onChange)
          : SignupPage(onChange: onChange),
      reverse: index == 0,
    );
  }
}
