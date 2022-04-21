import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyProgressIndicator extends StatelessWidget {
  final double size;
  final EdgeInsets margin;
  final Color? color;

  const MyProgressIndicator(
      {Key? key,
      this.size = 50,
      this.color,
      this.margin = const EdgeInsets.all(24)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      margin: margin,
      child: SpinKitCircle(
        // ignore: prefer_if_null_operators
        color: color != null
            ? color
            : Theme.of(context).brightness == Brightness.light
                ? Colors.grey[350]
                : Colors.white54,
        size: size,
      ),
    );
  }
}

class ThreeDotsProgress extends StatelessWidget {
  final double size;
  final EdgeInsets margin;
  final Alignment alignment;

  const ThreeDotsProgress(
      {Key? key,
      this.size = 50,
      this.alignment = Alignment.centerLeft,
      this.margin = const EdgeInsets.all(24)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size * 1.5,
      alignment: alignment,
      margin: margin,
      child: SpinKitThreeBounce(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[350]
            : Colors.white54,
        size: size,
      ),
    );
  }
}
