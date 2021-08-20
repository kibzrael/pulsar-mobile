import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';

class ChallengeOptions extends StatelessWidget {
  final Challenge challenge;

  ChallengeOptions(this.challenge);

  @override
  Widget build(BuildContext context) {
    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: (context) {});
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {});

    List<Option> options = [notification, report];
    return Options(options, share: true, shareText: 'challenge');
  }
}
