import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

class SignInfoProvider extends ChangeNotifier {
  PageController? get pageController => _pageController;

  late PageController _pageController;

  List<Interest> interests = [];

  int? _page;

  late SignUserInfo user;

  late String _signupUrl;

  String? token;

  SignInfoProvider() {
    _pageController = PageController();
    _signupUrl = getUrl(AuthUrls.signupUrl);
    user = SignUserInfo();
  }

  fetchInterests(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    interests = await userProvider.activeCategories(context);
  }

  Future<MyResponse> signup(
      String email, String username, String password) async {
    Uri url = Uri.parse(_signupUrl);
    http.Response requestResponse = await http.post(
      url,
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    MyResponse response = MyResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    }

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 300));

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

  submit(BuildContext context) async {
    File? profilePic;
    if (user.profilePic != null) {
      // split into three different qualities
      img.Image? image =
          img.decodeImage(File(user.profilePic!).readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);

        Directory dir = await getTemporaryDirectory();
        profilePic = await File(join(dir.path, '${DateTime.now()} resized.jpg'))
            .writeAsBytes(img.encodeJpg(resized));
      }
    }

    String profileUrl = getUrl(UserUrls.profile(user.id!));

    Dio dio = Dio();

    String birthday = user.birthday?.toString().split(' ')[0] ?? '';

    FormData form = FormData.fromMap({
      'category': user.category.name,
      'fullname': user.username,
      'DOB': birthday,
      'type': '',
      'interests': user.interests?.map((e) => e.name).join(',') ?? '',
      'profilePic': profilePic == null
          ? null
          : await MultipartFile.fromFile(profilePic.path,
              filename: 'profile.jpg',
              contentType: parser.MediaType('image', 'jpeg'))

      //  {
      //     'image': await MultipartFile.fromFile(profilePic.path,
      //         filename: 'profile.jpg',
      //         contentType: parser.MediaType('image', 'jpeg')),
      //     "type": "image/jpg"
      //   }
    });

    try {
      Response response = await dio.post(
        profileUrl,
        options: Options(headers: {
          'Authorization': token ?? '',
          "Content-type": "multipart/form-data",
        }),
        data: form,
        onSendProgress: (int sent, int total) {
          debugPrint("sent${sent.toString()} total${total.toString()}");
        },
      );

      if (response.statusCode == 200 && response.data is Map) {
        Map<String, dynamic> userJson = {};
        response.data['user'].forEach((key, value) {
          userJson.putIfAbsent(key, () => value);
        });
        User userObject = User.fromJson(userJson);
        await Provider.of<LoginProvider>(context, listen: false)
            .saveLogin(context, token: token!, user: userObject.toJson());

        debugPrint('Saved user');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // debugPrint(response.statusCode.toString());
    // debugPrint(response.data);

    return;
  }
}

class SignUserInfo {
  int? id;
  String? username;
  UserType? userType;
  DateTime? birthday;
  Interest category =
      Interest(name: 'Personal Account', user: 'Personal Account');
  String? profilePic;
  List<Interest>? interests;
}

enum UserType { solo, group }
