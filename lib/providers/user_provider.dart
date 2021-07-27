import 'package:flutter/material.dart';
import 'package:pulsar/classes/test_user.dart';

class UserProvider extends ChangeNotifier {
  User? user;

  String? get token => user?.token;

  UserProvider(Map<String, dynamic>? loggedUser) {
    if (loggedUser != null) setUser(loggedUser);
  }

  void setUser(Map<String, dynamic> newUser) {
    user = User.fromJson(newUser);
    notifyListeners();
    // String userString = jsonEncode(newUser);
    // prefs.setString('user', userString);
  }
}
