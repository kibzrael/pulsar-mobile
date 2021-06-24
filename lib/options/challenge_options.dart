import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';

class ChallengeOptions extends StatelessWidget {
  final Challenge challenge;

  ChallengeOptions(this.challenge);

  final List<Option> options = [
    Option(
        name: 'Notifications', icon: MyIcons.notifications, onPressed: () {}),
    Option(name: 'Report', icon: MyIcons.report, onPressed: () {}),
    Option(name: 'Share', icon: MyIcons.share, onPressed: () {})
  ];

  @override
  Widget build(BuildContext context) {
    return Options(options);
  }
}
