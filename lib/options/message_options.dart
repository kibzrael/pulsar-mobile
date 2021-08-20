import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';

class MessageOptions extends StatelessWidget {
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
    Option delete = Option(
        name: 'Delete Chat',
        color: Theme.of(context).colorScheme.error,
        icon: MyIcons.delete,
        onPressed: (context) {});

    List<Option> options = [favorite, mute, block, report, delete];
    return Options(options, share: false);
  }
}
