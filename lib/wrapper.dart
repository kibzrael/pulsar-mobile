import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/intro/intro.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/providers/login_provider.dart';

class Wrapper extends StatefulWidget {
  final Widget child;
  const Wrapper({Key? key, required this.child}) : super(key: key);
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool? loggedIn;

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);
    if (loggedIn != null) {
      if (loggedIn != provider.loggedIn) {
        if (provider.loggedIn == false) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const IntroPage()));
        } else if (provider.loggedIn == true) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BasicRoot()));
        }
      }
    }
    loggedIn = provider.loggedIn!;
    return widget.child;
  }
}
