import 'package:flutter/material.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/widgets/route.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Navigator(
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return myPageRoute(
              builder: (context) => const BasicRoot(), settings: settings);
        },
      ),
    );
  }
}
