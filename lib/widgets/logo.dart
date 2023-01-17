import 'package:flutter/material.dart';

class PulsarLogo extends StatelessWidget {
  final double size;
  const PulsarLogo({Key? key, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/logo.png',
        width: size, height: size, fit: BoxFit.cover);
  }
}

class PulsarTextLogo extends StatelessWidget {
  const PulsarTextLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Pulsar',
        style: TextStyle(
            fontSize: 100,
            fontFamily: 'Champagne',
            fontWeight: FontWeight.bold));
  }
}
