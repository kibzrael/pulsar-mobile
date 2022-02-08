import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';

class ChatOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Option favorite = Option(
        name: 'Favorite', icon: MyIcons.favorite, onPressed: (context) {});
    Option mute =
        Option(name: 'Mute', icon: MyIcons.mute, onPressed: (context) {});
    Option block =
        Option(name: 'Block', icon: MyIcons.block, onPressed: (context) {});
    Option report = Option(
        name: 'Report',
        color: Theme.of(context).colorScheme.error,
        icon: MyIcons.report,
        onPressed: (context) {});

    List<Option> options = [favorite, mute, block, report];
    return Options(options, share: false);
  }
}
