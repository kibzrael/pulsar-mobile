import 'package:flutter/material.dart';

class PulsarLogo extends StatelessWidget {
  final double size;
  PulsarLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/logo.png'
                : 'assets/logo 1.png',
            width: size,
            height: size,
            fit: BoxFit.cover),
      ),
    );
  }
}

class PulsarTextLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Pulsar',
        style: TextStyle(
            fontSize: 72,
            fontFamily: 'Champagne',
            fontWeight: FontWeight.bold));
  }
}
