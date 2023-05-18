import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';
import 'package:pulsar/providers/localization_provider.dart';

class ChallengeOptions extends StatelessWidget {
  final Challenge challenge;

  const ChallengeOptions(this.challenge, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Option notification = Option(
        name: local(context).postNotifications,
        icon: MyIcons.notifications,
        onPressed: (context) {});
    Option report = Option(
        name: local(context).report,
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {});

    List<Option> options = [notification, report];
    return Options(options, share: true, shareText: 'challenge');
  }
}
