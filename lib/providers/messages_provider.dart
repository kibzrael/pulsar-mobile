import 'package:flutter/material.dart';
import 'package:pulsar/classes/message.dart';

class MessagesProvider extends ChangeNotifier {
  List<Message> selectedMessages = [];

  MessagesProvider() {
    initialize();
  }

  initialize() async {}

  clearMessages() {
    selectedMessages.clear();

    notifyListeners();
  }

  addSelectedMessage(Message message) {
    selectedMessages.add(message);
    notifyListeners();
  }

  removeSelectedMessage(Message message) {
    selectedMessages
        .removeWhere((element) => element.user.id == message.user.id);
    notifyListeners();
  }
}
