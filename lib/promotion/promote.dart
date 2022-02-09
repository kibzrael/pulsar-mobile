import 'package:flutter/material.dart';

class Promote extends StatefulWidget {
  const Promote({Key? key}) : super(key: key);

  @override
  _PromoteState createState() => _PromoteState();
}

class _PromoteState extends State<Promote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promote'),
      ),
    );
  }
}
