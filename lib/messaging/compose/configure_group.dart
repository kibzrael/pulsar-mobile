import 'package:flutter/material.dart';
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/messaging_screen.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/text_button.dart';

class ConfigureGroup extends StatefulWidget {
  final List<User> recipients;

  ConfigureGroup(this.recipients);

  @override
  _ConfigureGroupState createState() => _ConfigureGroupState();
}

class _ConfigureGroupState extends State<ConfigureGroup> {
  late List<User> members;

  @override
  void initState() {
    super.initState();
    members = widget.recipients;
  }

  @override
  Widget build(BuildContext context) {
    if (!members.contains(tahlia)) members.insert(0, tahlia);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        actions: [
          MyTextButton(
            text: 'Create',
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName("/"));
              Navigator.of(context, rootNavigator: true).push(myPageRoute(
                builder: (context) => MessagingScreen(
                  Chat(members,
                      category: 'Music',
                      name: 'Karoke lads',
                      description: 'No bio\nKaraoke',
                      dateFormed: DateTime.now()),
                  isNew: true,
                ),
              ));
            },
          )
        ],
      ),
    );
  }
}
