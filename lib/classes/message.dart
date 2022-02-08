import 'package:pulsar/classes/user.dart';

class Message {
  User user;
  //User recipient;
  String message;
  bool isRead;
  DateTime time;
  // bool encrypted;
  String? attachment;
  // Message replyTo;
  // bool isLiked;

  Message(
      {required this.user,
      //required this.recipient,
      required this.message,
      this.isRead = false,
      required this.time,
      this.attachment});

  markAsRead() {}

  reply() {}

  like() {}

  unsend() {}
}
