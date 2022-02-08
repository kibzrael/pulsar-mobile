import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/options/options.dart';

class PostOptions extends StatelessWidget {
  final Post post;

  PostOptions(this.post);

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
    Option block =
        Option(name: 'Block', icon: MyIcons.block, onPressed: (context) {});
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {});

    Option download = Option(
        name: 'Download', icon: MyIcons.download, onPressed: (context) {});

    List<Option> options = [
      notification,
      download,
      notInterested,
      block,
      report
    ];

    return Options(options, share: true, shareText: 'post');
  }
}
