import 'package:flutter/cupertino.dart';

class Option {
  String name;
  IconData icon;
  void Function() onPressed;

  Option({required this.name, required this.icon, required this.onPressed});
}
