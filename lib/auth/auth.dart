import 'package:flutter/material.dart';
import 'package:pulsar/auth/login_page.dart';
import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/widgets/transitions.dart';

class AuthScreen extends StatefulWidget {
  final int initialPage;
  const AuthScreen({Key? key, this.initialPage = 0}) : super(key: key);
  @override
  State<AuthScreen> createState() => _AuthScreenState();
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
      fill: Theme.of(context).scaffoldBackgroundColor,
      reverse: index == 0,
      child: index == 0
          ? LoginPage(onChange: onChange)
          : SignupPage(onChange: onChange),
    );
  }
}
