import 'package:flutter/material.dart';

class PulsarLogo extends StatelessWidget {
  final double size;
  const PulsarLogo({Key? key, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: Theme.of(context).brightness == Brightness.dark
          ? const ColorFilter.matrix(<double>[
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
          : const ColorFilter.matrix(<double>[
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
