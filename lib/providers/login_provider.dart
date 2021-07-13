import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool? _loggedIn;

  bool? get loggedIn => _loggedIn;

  late String _loginUrl;

  LoginProvider() {
    _loggedIn = false;
    getState();
    _loginUrl = getUrl(AuthUrls.loginUrl);
  }

  Future<LoginResponse> login(info, password) async {
    Uri url = Uri.parse(_loginUrl);
    http.Response requestResponse = await http.post(url, body: {
      'info': info,
      'password': password,
    });

    LoginResponse response = LoginResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        _loggedIn = true;
        notifyListeners();
        saveLogin();
      });
    }
    return response;
  }

  getState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool('loggedIn') ?? false;
    notifyListeners();
  }

  saveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
  }

  logout() async {
    _loggedIn = false;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
  }
}

class LoginResponse {
  int? statusCode;
  Map? body;
}
