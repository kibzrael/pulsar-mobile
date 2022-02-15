import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';

class RecoverAccountProvider extends ChangeNotifier {
  PageController? get pageController => _pageController;

  late PageController _pageController;

  int? _page;

  User? user;

  int? code;
  String? token;

  RecoverAccountProvider() {
    _pageController = PageController();
  }

  previousPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! - 1);
  }

  nextPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! + 1);
  }

  Future<RecoverAccountResponse> recoverAccount(String info) async {
    String recoverAccountUrl = getUrl(AuthUrls.recoverAccount);

    http.Response requestResponse =
        await http.post(Uri.parse(recoverAccountUrl), body: {'info': info});

    RecoverAccountResponse response = RecoverAccountResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
      code = body['code'];
      user = User.fromJson(body['user']);
      token = body['user']['jwtToken'];
    } else {
      response.body = {
        'message':
            'There has been a problem processing your request. Please try again later.'
      };
    }
    return response;
  }

  int verifyCode(String codeEntry) {
    if (code.toString() == codeEntry) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<RecoverAccountResponse> resetPassword(String password) async {
    String resetPasswordUrl = getUrl(AuthUrls.resetPassword);

    http.Response requestResponse = await http.post(Uri.parse(resetPasswordUrl),
        headers: {'Authorization': token!}, body: {'password': password});

    RecoverAccountResponse response = RecoverAccountResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    } else {
      response.body = {
        'message':
            'There has been a problem processing your request. Please try again later.'
      };
    }
    return response;
  }
}

class RecoverAccountResponse {
  int? statusCode;
  Map? body;
}
