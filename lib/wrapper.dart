import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/intro/intro.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/route.dart';

class Wrapper extends StatefulWidget {
  final Widget child;
  const Wrapper({Key? key, required this.child}) : super(key: key);
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool? loggedIn;

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);
    if (loggedIn != null) {
      if (loggedIn != provider.loggedIn) {
        if (provider.loggedIn == false) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              myPageRoute(builder: (context) => const IntroPage()),
              (route) => false);
        } else if (provider.loggedIn == true) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              myPageRoute(builder: (context) => const BasicRoot()),
              (route) => false);
        }
      }
    }
    loggedIn = provider.loggedIn!;
    return widget.child;
  }
}
