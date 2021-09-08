import 'package:flutter/material.dart';

class PulsarLogo extends StatelessWidget {
  final double size;
  PulsarLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: Theme.of(context).brightness == Brightness.dark
          ? ColorFilter.matrix(<double>[
              -1,
              0,
              0,
              0,
              255,
              0,
              -1,
              0,
              0,
              255,
              0,
              0,
              -1,
              0,
              255,
              0,
              0,
              0,
              1,
              0,
            ])
          : ColorFilter.matrix(<double>[
              1,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
      child: Image.asset('assets/logo.png',
          width: size, height: size, fit: BoxFit.cover),
    );
  }
}

class PulsarTextLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Pulsar',
        style: TextStyle(
            fontSize: 100,
            fontFamily: 'Champagne',
            fontWeight: FontWeight.bold));
  }
}
