import 'package:flutter/cupertino.dart';

class Option {
  String name;
  IconData icon;
  Color? color;
  void Function(BuildContext context) onPressed;

  Option(
      {required this.name,
      required this.icon,
      required this.onPressed,
      this.color});
}
