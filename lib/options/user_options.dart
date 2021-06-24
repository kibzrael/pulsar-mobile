import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/options/options.dart';

class UserOptions extends StatelessWidget {
  final User user;

  UserOptions(this.user);

  final List<Option> options = [
    Option(
        name: 'Notifications', icon: MyIcons.notifications, onPressed: () {}),
    Option(name: 'Block', icon: MyIcons.block, onPressed: () {}),
    Option(name: 'Report', icon: MyIcons.report, onPressed: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Options(options);
  }
}
