import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/providers/facebook.dart';
import 'package:pulsar/auth/providers/google.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/providers/user_provider.dart';

import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:sqflite/sqflite.dart';

class LoginProvider extends ChangeNotifier {
  bool? _loggedIn;

  bool? get loggedIn => _loggedIn;

  String? deviceToken;

  late String _loginUrl;

  LoginProvider(this.deviceToken, bool isLoggedIn) {
    _loggedIn = isLoggedIn;
    _loginUrl = getUrl(AuthUrls.loginUrl);
  }

  Future<LoginResponse> login(BuildContext context, info, password) async {
    Uri url = Uri.parse(_loginUrl);
    LoginResponse response = LoginResponse();
    try {
      http.Response requestResponse = await http.post(url, body: {
        'info': info,
        'password': password,
        'deviceToken': deviceToken ?? ''
      });

      response.statusCode = requestResponse.statusCode;
      //
      var body = jsonDecode(requestResponse.body);
      if (body is Map) {
        response.body = body;
      }
    } catch (e) {
      response.statusCode = 503;
      response.body = {
        'message':
            'There has been a problem processing your request. Please try again later.'
      };
    }
    if (response.statusCode == 200) {
      saveLogin(context,
          token: response.body!['user']['jwtToken'],
          user: response.body!['user']);
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _loggedIn = true;
        Navigator.of(context).pushReplacementNamed('/');

        notifyListeners();
      });
    }
    return response;
  }

  googleSignin(BuildContext context) async {
    GoogleSignInAccount? account = await GoogleProvider.signin();

    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;

      LinkedAccount linkedAccount = LinkedAccount(
        'google',
        id: account.id,
        email: account.email,
        authCode: account.serverAuthCode,
        accessToken: authentication.accessToken ?? '',
        photo: account.photoUrl,
      );

      Uri uri = Uri.parse(getUrl(AuthUrls.googleSignin));
      http.Response response = await http.post(uri, body: {
        'id': account.id,
        'email': account.email,
        'access_token': authentication.accessToken,
        'auth_code': account.serverAuthCode,
        'device_token': deviceToken ?? ''
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['linked']) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account Linked Successfully")));
        }
        saveLogin(context, token: data['user']['jwtToken'], user: data['user']);
        _loggedIn = true;
        Navigator.of(context).pushReplacementNamed('/');
        notifyListeners();
      } else if (response.statusCode == 404) {
        SignInfoProvider provider =
            Provider.of<SignInfoProvider>(context, listen: false);
        provider.providerSignup(context, linkedAccount);
      } else {
        Fluttertoast.showToast(msg: 'Error Signing in.');
      }
    }
  }

  facebookSignin(BuildContext context) async {
    AccessToken? accessToken = await FacebookProvider.signIn();
    if (accessToken != null) {
      Map<String, dynamic>? userData = await FacebookProvider.fetchUser();
      if (userData != null) {
        LinkedAccount account = LinkedAccount('facebook',
            id: accessToken.userId,
            email: userData['email'],
            accessToken: accessToken.token,
            photo: userData['picture']['data']['url'],
            birthday: userData['birthday']);
        Uri uri = Uri.parse(getUrl(AuthUrls.facebookSignin));
        http.Response response = await http.post(uri, body: {
          'id': accessToken.userId,
          'email': account.email,
          'access_token': accessToken.token,
          'device_token': deviceToken ?? ''
        });
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['linked']) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account Linked Successfully")));
          }
          saveLogin(context,
              token: data['user']['jwtToken'], user: data['user']);
          _loggedIn = true;
          Navigator.of(context).pushReplacementNamed('/');
          notifyListeners();
        } else if (response.statusCode == 404) {
          SignInfoProvider provider =
              Provider.of<SignInfoProvider>(context, listen: false);
          provider.providerSignup(context, account);
        } else {
          Fluttertoast.showToast(msg: 'Error Signing in.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Error fetching Data.');
      }
    } else {
      Fluttertoast.showToast(msg: 'Error Signing in');
    }
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
      'thumbnail': user['profile_pic']?['thumbnail'],
      'medium': user['profile_pic']?['medium'],
      'high': user['profile_pic']?['high'],
      'fullname': user['fullname'],
      'email': user['email'],
      'phone': user['phone'],
      'bio': user['bio'],
      'portfolio': user['portfolio'],
      'posts': user['posts'],
      'followers': user['followers'],
      'is_superuser': user['is_superuser'] ? 1 : 0,
      'token': token,
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
