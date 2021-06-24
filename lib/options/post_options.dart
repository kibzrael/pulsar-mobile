import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/options/options.dart';

class PostOptions extends StatelessWidget {
  final Post post;

  PostOptions(this.post);

  final List<Option> options = [
    Option(
        name: 'Notifications', icon: MyIcons.notifications, onPressed: () {}),
    Option(name: 'Block', icon: MyIcons.block, onPressed: () {}),
    Option(name: 'Report', icon: MyIcons.report, onPressed: () {}),
    Option(name: 'Share', icon: MyIcons.share, onPressed: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Options(options);
  }
}
