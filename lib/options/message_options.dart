import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';

class MessageOptions extends StatelessWidget {
  final List<Option> options = [
    Option(name: 'Favorite', icon: MyIcons.favorite, onPressed: () {}),
    Option(name: 'Mute', icon: MyIcons.mute, onPressed: () {}),
    Option(name: 'Block', icon: MyIcons.block, onPressed: () {}),
    Option(name: 'Report', icon: MyIcons.report, onPressed: () {}),
    Option(name: 'Delete Chat', icon: MyIcons.delete, onPressed: () {})
  ];

  @override
  Widget build(BuildContext context) {
    return Options(options);
  }
}
