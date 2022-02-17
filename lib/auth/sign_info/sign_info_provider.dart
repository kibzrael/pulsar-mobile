import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
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
    String categoriesJson = await DefaultAssetBundle.of(context)
        .loadString('assets/categories.json');
    var categories = jsonDecode(categoriesJson);
    interests.clear();
    categories.forEach((key, item) {
      Interest interest = Interest(
        name: key,
        category: item['user'],
        pCategory: item['users'],
        coverPhoto: Photo(thumbnail: item['cover']),
      );
      interests.add(interest);
      Map<String, dynamic>? subcategories = item['subcategories'];
      if (subcategories != null) {
        subcategories.forEach((key, item) {
          interests.add(
            Interest(
                name: key,
                category: item['user'] ?? interest.category,
                pCategory: item['users'] ?? interest.pCategory,
                coverPhoto: item['cover'] != null
                    ? Photo(thumbnail: item['cover'])
                    : interest.coverPhoto,
                parent: interest),
          );
        });
      }
    });
  }

  Future<SignupResponse> signup(
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

    SignupResponse response = SignupResponse();
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

  submit() async {
    File? profilePic;
    if (user.profilePic != null) {
      // split into three different qualities
      img.Image? image =
          img.decodeImage(File(user.profilePic!).readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);

        Directory dir = await getApplicationDocumentsDirectory();
        profilePic = await File(join(dir.path, '${DateTime.now()} resized.jpg'))
            .writeAsBytes(img.encodeJpg(resized));
      }
    }

    String profileUrl = getUrl(UserUrls.profile(user.id!));

    Dio dio = Dio();

    FormData form = FormData.fromMap({
      'category': user.category,
      'fullname': user.username,
      'DOB': user.birthday,
      'type': '',
      'interests': [],
      'profilePic': profilePic == null
          ? null
          : {
              'image': await MultipartFile.fromFile(profilePic.path,
                  filename: 'profile.jpg',
                  contentType: parser.MediaType('image', 'jpeg')),
              "type": "image/jpg"
            }
    });

    Response response = await dio.post(
      profileUrl,
      options: Options(headers: {
        'Authorization': token!,
        "Content-type": "multipart/form-data",
      }),
      data: form,
      onSendProgress: (int sent, int total) {
        debugPrint("sent${sent.toString()} total${total.toString()}");
      },
    );

    debugPrint(response.statusCode.toString());
    debugPrint(response.data);

    return;
  }
}

class SignupResponse {
  int? statusCode;
  Map? body;
}

class SignUserInfo {
  int? id;
  String? username;
  UserType? userType;
  DateTime? birthday;
  Interest? category;
  String? profilePic;
  List<Interest>? interests;
}

enum UserType { solo, group }
