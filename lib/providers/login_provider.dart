import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/user_provider.dart';

import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:sqflite/sqflite.dart';

class LoginProvider extends ChangeNotifier {
  bool? _loggedIn;

  bool? get loggedIn => _loggedIn;

  late String _loginUrl;

  LoginProvider(bool isLoggedIn) {
    _loggedIn = isLoggedIn;
    _loginUrl = getUrl(AuthUrls.loginUrl);
  }

  Future<LoginResponse> login(BuildContext context, info, password) async {
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
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      await saveLogin(context,
          token: response.body!['user']['jwtToken'],
          user: response.body!['user']);
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _loggedIn = true;
        notifyListeners();
      });
    }
    return response;
  }

  signup(BuildContext context,
      {required String token, required Map<String, dynamic> user}) async {
    await saveLogin(context, token: token, user: user);
    _loggedIn = true;
    notifyListeners();
  }

  saveLogin(BuildContext context,
      {required String token, required Map<String, dynamic> user}) async {
    Provider.of<UserProvider>(context, listen: false).setUser(user);
    Database db =
        await openDatabase(join(await getDatabasesPath(), 'pulsar.db'));

    await db.delete('users');

    db.insert('users', {
      'id': user['id'],
      'username': user['username'],
      'category': user['category'],
      'fullname': user['fullname'],
      'email': user['email'],
      'phone': user['phone'],
      'bio': user['bio'],
      'portfolio': user['portfolio'],
      'token': token
    });

    return;
  }

  logout(BuildContext context) async {
    _loggedIn = false;
    Database db =
        await openDatabase(join(await getDatabasesPath(), 'pulsar.db'));

    await db.delete('users');
    notifyListeners();
  }
}

class LoginResponse {
  int? statusCode;
  Map? body;
}
