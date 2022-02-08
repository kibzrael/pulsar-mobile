import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/messages_card.dart';
import 'package:pulsar/classes/message.dart';

class Chats extends StatefulWidget {
  final ScrollController scrollController;
  Chats({required this.scrollController});
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Message> messages = [
    Message(
        user: tom,
        message: 'Hi there! have you watched the latest episode on BBT??',
        isRead: true,
        time: DateTime.now().subtract(Duration(minutes: 24))),
    Message(
        user: melissa,
        message: 'I will be available tomorrow, wanna hang out',
        time: DateTime.now().subtract(Duration(hours: 7))),
    Message(
        user: chris,
        message: 'Bro that post was awesome!!',
        isRead: true,
        time: DateTime.now().subtract(Duration(days: 1))),
    Message(
        user: joy,
        message: 'Am joy, I was wondering if i could get to know you.',
        isRead: false,
        time: DateTime.now().subtract(Duration(days: 2))),
    Message(
        user: rael,
        message: 'Wanna see someting interesting',
        isRead: true,
        time: DateTime.now().subtract(Duration(days: 8))),
    Message(
        user: joe,
        message: 'Hey there',
        isRead: false,
        time: DateTime.now().subtract(Duration(days: 36))),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      controller: widget.scrollController,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return MessagesCard(messages[index]);
      },
    );
  }
}
