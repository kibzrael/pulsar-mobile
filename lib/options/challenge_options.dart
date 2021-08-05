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
    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: () {});
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: () {});

    List<Option> options = [notification, report];
    return Options(options, share: true, shareText: 'challenge');
  }
}
