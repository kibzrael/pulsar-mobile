import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/message.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/spam/spam_message_card.dart';

class SpamInbox extends StatefulWidget {
  const SpamInbox({Key? key}) : super(key: key);

  @override
  _SpamInboxState createState() => _SpamInboxState();
}

class _SpamInboxState extends State<SpamInbox> {
  List<Message> messages = [
    Message(
        user: tom,
        message: 'Hi there! have you watched the latest episode on BBT??',
        isRead: true,
        time: DateTime.now().subtract(const Duration(minutes: 24))),
    Message(
        user: melissa,
        message: 'I will be available tomorrow, wanna hang out',
        time: DateTime.now().subtract(const Duration(hours: 7))),
    Message(
        user: chris,
        message: 'Bro that post was awesome!!',
        isRead: true,
        time: DateTime.now().subtract(const Duration(days: 1))),
    Message(
        user: joy,
        message: 'Am joy, I was wondering if i could get to know you.',
        isRead: false,
        time: DateTime.now().subtract(const Duration(days: 2))),
    Message(
        user: evah,
        message: 'Wanna see someting interesting',
        isRead: true,
        time: DateTime.now().subtract(const Duration(days: 8))),
    Message(
        user: joe,
        message: 'Hey there',
        isRead: false,
        time: DateTime.now().subtract(const Duration(days: 36))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spam Inbox'),
        actions: [
          IconButton(
            icon: Icon(MyIcons.clearAll),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return SpamMessagesCard(messages[index]);
        },
      ),
    );
  }
}
