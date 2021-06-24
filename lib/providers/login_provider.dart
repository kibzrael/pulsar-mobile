import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool? _loggedIn;

  bool? get loggedIn => _loggedIn;

  LoginProvider() {
    _loggedIn = true;
  }

  login() {
    _loggedIn = true;
    notifyListeners();
  }

  logout() {
    _loggedIn = false;
    notifyListeners();
  }
}
