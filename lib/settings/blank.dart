import 'package:flutter/material.dart';

class Blank extends StatefulWidget {
  @override
  _BlankState createState() => _BlankState();
}

class _BlankState extends State<Blank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blank'),
      ),
    );
  }
}
