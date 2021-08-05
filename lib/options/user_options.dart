import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/options/options.dart';

class UserOptions extends StatelessWidget {
  final User user;

  UserOptions(this.user);

  @override
  Widget build(BuildContext context) {
    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: () {});
    Option block = Option(name: 'Block', icon: MyIcons.block, onPressed: () {});
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: () {});

    List<Option> options = [notification, block, report];
    return Options(
      options,
      share: true,
      shareText: 'user',
    );
  }
}
