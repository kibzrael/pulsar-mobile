import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/options/options.dart';

class TagOptions extends StatelessWidget {
  final String tag;

  TagOptions(this.tag);

  @override
  Widget build(BuildContext context) {
    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: (context) {});

    Option notInterested = Option(
        name: 'Not Interested',
        icon: MyIcons.notInterested,
        onPressed: (context) {});

    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {});

    List<Option> options = [notification, notInterested, report];
    return Options(options, share: true, shareText: 'Tag');
  }
}
