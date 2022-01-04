import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';

class SignInfoProvider extends ChangeNotifier {
  PageController? get pageController => _pageController;

  late PageController _pageController;

  List<Interest> interests = [];

  int? _page;

  late SignUserInfo user;

  late String _signupUrl;

  SignInfoProvider() {
    _pageController = PageController();
    _signupUrl = getUrl(AuthUrls.signupUrl);
    user = SignUserInfo();
  }

  fetchInterests(BuildContext context) async {
    String categoriesJson = await DefaultAssetBundle.of(context)
        .loadString('assets/categories/categories.json');
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
    http.Response requestResponse = await http.post(url, body: {
      'username': username,
      'email': email,
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

  submit() async {
    if (user.profilePic != null) {
      // split into three different qualities
      img.Image? image =
          img.decodeImage(File(user.profilePic!.thumbnail).readAsBytesSync());
      if (image != null) {
        img.Image thumbnail = img.copyResize(image, width: 120);
        img.Image medium = img.copyResize(image, width: 240);
        img.Image high = img.copyResize(image, width: 480);

        Directory dir = await getApplicationDocumentsDirectory();
        File thumbnailFile =
            await File(join(dir.path, '${DateTime.now()}', '-thumbnail.jpg'))
                .writeAsBytes(img.encodeJpg(thumbnail));
        File mediumFile =
            await File(join(dir.path, '${DateTime.now()}', '-medium.jpg'))
                .writeAsBytes(img.encodeJpg(medium));
        File highFile =
            await File(join(dir.path, '${DateTime.now()}', '-high.jpg'))
                .writeAsBytes(img.encodeJpg(high));

        FirebaseStorage storage = FirebaseStorage.instance;
        Reference profilePicThumbnail =
            storage.ref('profile pictures/${user.id}-thumbnail.jpg');
        Reference profilePicMedium =
            storage.ref('profile pictures/${user.id}-medium.jpg');
        Reference profilePicHigh =
            storage.ref('profile pictures/${user.id}-high.jpg');

        await profilePicThumbnail.putFile(thumbnailFile);
        await profilePicMedium.putFile(mediumFile);
        await profilePicHigh.putFile(highFile);

        String thumbnailUrl = await profilePicThumbnail.getDownloadURL();
        String mediumUrl = await profilePicMedium.getDownloadURL();
        String highUrl = await profilePicHigh.getDownloadURL();
        user.profilePic = Photo(
          thumbnail: thumbnailUrl,
          medium: mediumUrl,
          high: highUrl,
        );
      }
    }

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
  Photo? profilePic;
  List<Interest>? interests;
}

enum UserType { solo, group }
