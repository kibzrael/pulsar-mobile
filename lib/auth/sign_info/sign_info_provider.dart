import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pulsar/classes/interest.dart';
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
        coverPhoto: item['cover'],
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
                coverPhoto: item['cover'] ?? interest.coverPhoto,
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

    // var request = http.MultipartRequest('POST', Uri.parse(profileUrl));
    // //   ..fields['fullname'] = user.username!;
    // // if (user.birthday != null)
    // //   request.fields['DOB'] =
    // //       '${user.birthday!.year}-${user.birthday!.month}-${user.birthday!.day}';
    // if (profilePic != null)
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'profilePic', profilePic.path,
    //       contentType: parser.MediaType('images', 'jpeg')));

    // print(request.fields);
    // print(request.files);
    // http.StreamedResponse response = await request.send();
    await Future.delayed(Duration(seconds: 2));

    // http.Response response = await http.post(Uri.parse(profileUrl), headers: {
    //   'Authorization': token!
    // }, body: {
    //   'fullname': user.username,
    //   'DOB': user.birthday == null
    //       ? null
    //       : '${user.birthday!.year}-${user.birthday!.month}-${user.birthday!.day}',
    //   'profilePic': profilePic == null
    //       ? null
    //       : http.MultipartFile.fromPath('profilePic', profilePic.path)
    // });

    // print(response.statusCode);

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
