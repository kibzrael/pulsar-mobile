import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';

class SignInfoProvider extends ChangeNotifier {
  PageController? get pageController => _pageController;

  late PageController _pageController;

  int? _page;

  SignupInfo info;

  late String _signupUrl;

  SignInfoProvider(this.info) {
    _pageController = PageController();
    _signupUrl = getUrl(AuthUrls.signupUrl);
  }

  Future<SignupResponse> signup(String username, String password) async {
    Uri url = Uri.parse(_signupUrl);
    http.Response requestResponse = await http.post(url, body: {
      'username': username,
      'email': info.email ?? '',
      'phone': info.phone ?? '',
      'password': password,
    });

    SignupResponse response = SignupResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 300));

      notifyListeners();
    }
    return response;
  }

  previousPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! - 1);
  }

  nextPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! + 1);
  }
}

class SignupResponse {
  int? statusCode;
  Map? body;
}
