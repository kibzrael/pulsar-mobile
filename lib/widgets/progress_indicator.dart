import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyProgressIndicator extends StatelessWidget {
  final double size;
  final EdgeInsets margin;

  const MyProgressIndicator({Key? key, this.size = 50, this.margin = const EdgeInsets.all(24)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      margin: margin,
      child: SpinKitCircle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[350]
            : Colors.white54,
        size: size,
      ),
    );
  }
}
