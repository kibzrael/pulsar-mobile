import 'package:flutter/material.dart';

class PulsarLogo extends StatelessWidget {
  final double size;
  PulsarLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ColorFiltered(
        colorFilter: Theme.of(context).brightness == Brightness.light
            ? ColorFilter.matrix(<double>[
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
                0
              ])
            : ColorFilter.matrix(<double>[
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
                0
              ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset('assets/logo.jpg',
              width: size, height: size, fit: BoxFit.cover),
        ),
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
