import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pulsar/classes/message.dart';

class MessagesProvider extends ChangeNotifier {
  List<Message> selectedMessages = [];

  MessagesProvider() {
    initialize();
  }

  initialize() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> chats = await firestore
        .collection('Messaging')
        .where('members.id', arrayContains: 1)
        .get();
    Fluttertoast.showToast(msg: chats.docs.toString());
  }

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
