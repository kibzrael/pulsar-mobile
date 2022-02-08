import 'package:flutter/material.dart';

class ChangePhone extends StatefulWidget {
  const ChangePhone({Key? key}) : super(key: key);

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Change phone')));
  }
}
