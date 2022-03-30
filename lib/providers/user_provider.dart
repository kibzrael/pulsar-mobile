import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/user.dart';
import 'package:image/image.dart' as img;
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

class UserProvider extends ChangeNotifier {
  late User user;

  List<Interest>? categories;

  String? get token => user.token;

  UserProvider(Map<String, dynamic>? loggedUser) {
    if (loggedUser != null) setUser(loggedUser);
    fetchCategories();
  }

  void setUser(Map<String, dynamic> newUser) {
    Map<String, dynamic> userJson = {};

    newUser.forEach((key, value) {
      if (!['thumbnail', 'medium', 'high', 'token', 'is_superuser']
          .contains(key)) {
        userJson.putIfAbsent(key, () => value);
      }
    });

    userJson.putIfAbsent('jwtToken', () => newUser['token']);

    if (newUser['thumbnail'] != null) {
      userJson.putIfAbsent(
          'profile_pic',
          () => {
                'thumbnail': newUser['thumbnail'],
                'medium': newUser['medium'],
                'high': newUser['high'],
              });
    }

    userJson.putIfAbsent('is_superuser',
        () => newUser['is_superuser'] == 1 || newUser['is_superuser']);

    user = User.fromJson(userJson);
    notifyListeners();
    // String userString = jsonEncode(newUser);
    // prefs.setString('user', userString);
  }

  Future<MyResponse> editProfile(BuildContext context,
      {String? category,
      required String bio,
      required String fullname,
      required String portfolio,
      String? birthday,
      File? profilePic}) async {
    File? resizedProfilePic;
    if (profilePic != null) {
      img.Image? image = img.decodeImage(profilePic.readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);
        String identifier = '${DateTime.now()}'.replaceAll('.', '');
        Directory dir = await getTemporaryDirectory();
        resizedProfilePic = await File(join(dir.path, '$identifier.jpg'))
            .writeAsBytes(img.encodeJpg(resized));
      }
    }
    String profileUrl = getUrl(UserUrls.profile(user.id));
    Dio dio = Dio();
    debugPrint(resizedProfilePic?.path);

    FormData form = FormData.fromMap({
      'category': category,
      'fullname': fullname,
      'bio': bio,
      'portfolio': portfolio,
      'DOB': birthday,
      'profilePic': resizedProfilePic == null
          ? null
          : await MultipartFile.fromFile(resizedProfilePic.path,
              filename: 'profile.jpg',
              contentType: parser.MediaType('image', 'jpeg')),
    });

    MyResponse response = MyResponse();
    try {
      Response requestResponse = await dio.post(
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

      if (requestResponse.statusCode == 200 && requestResponse.data is Map) {
        if (resizedProfilePic != null) {
          CachedNetworkImage.evictFromCache(user.profilePic?.thumbnail ?? '');
          CachedNetworkImage.evictFromCache(user.profilePic?.medium ?? '');
          CachedNetworkImage.evictFromCache(user.profilePic?.high ?? '');
        }
        Map<String, dynamic> userJson = user.toJson();
        requestResponse.data['user'].forEach((key, value) {
          if (userJson.containsKey(key)) {
            userJson.update(key, (_) => value);
          }
        });
        user = User.fromJson(userJson);
        notifyListeners();
        await Provider.of<LoginProvider>(context, listen: false)
            .saveLogin(context, token: token!, user: user.toJson());
      }

      response.statusCode = requestResponse.statusCode;
      if (requestResponse.data is Map) {
        response.body = requestResponse.data;
      } else {
        response.body = {
          'message':
              'There has been a problem processing your request. Please try again later.'
        };
      }
    } catch (e) {
      response.statusCode = 503;
      response.body = {
        'message':
            'There has been a problem processing your request. Please try again later.'
      };
      debugPrint(e.toString());
    }
    return response;
  }

  Future<MyResponse> changeUsername(
      BuildContext context, String username) async {
    String url = getUrl(UserUrls.changeUsername);
    http.Response requestResponse = await http.post(Uri.parse(url), headers: {
      'Authorization': token ?? '',
    }, body: {
      'username': username
    });
    MyResponse response = MyResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    }

    if (response.statusCode == 200) {
      user.username = username;
      await Provider.of<LoginProvider>(context, listen: false)
          .saveLogin(context, token: token!, user: user.toJson());
      notifyListeners();
    }
    return response;
  }

  Future fetchCategories() async {
    String url = getUrl(UserUrls.categories);
    http.Response response =
        await http.get(Uri.parse(url), headers: {"Authorization": token ?? ''});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var categoriesJson = List<Map<String, dynamic>>.from(body['categories']);
      categories = [];
      for (Map<String, dynamic> category in categoriesJson) {
        Interest interest = Interest.fromJson(category);
        categories!.add(interest);
        for (Map<String, dynamic> subCategory in category['subCategories']) {
          Interest subInterest = Interest.fromJson(subCategory);
          subInterest.parent = interest;
          categories!.add(subInterest);
        }
      }
    }
  }

  notify() {
    notifyListeners();
  }
}
