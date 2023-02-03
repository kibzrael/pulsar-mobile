import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/messages_card.dart';
import 'package:pulsar/classes/message.dart';

class Chats extends StatefulWidget {
  final ScrollController scrollController;
  const Chats({Key? key, required this.scrollController}) : super(key: key);
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
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
        user: thomas,
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
