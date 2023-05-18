import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';
import 'package:pulsar/providers/localization_provider.dart';

class TagOptions extends StatelessWidget {
  final String tag;

  const TagOptions(this.tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Option notification = Option(
        name: local(context).postNotifications,
        icon: MyIcons.notifications,
        onPressed: (context) {});

    Option notInterested = Option(
        name: local(context).notInterested,
        icon: MyIcons.notInterested,
        onPressed: (context) {});

    Option report = Option(
        name: local(context).report,
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {});

    List<Option> options = [notification, notInterested, report];
    return Options(options, share: true, shareText: 'Tag');
  }
}
